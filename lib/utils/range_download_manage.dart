import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'md5_utils.dart';

/*
 * 文件下载
 * 懒加载单例
 */
class DownLoadManage {
  //用于记录正在下载的url，避免重复下载

  var downloadingUrls = <String, CancelToken>{};

  // 单例公开访问点
  factory DownLoadManage() => _getInstance()!;

  // 静态私有成员，没有初始化
  static DownLoadManage? _instance;

  // 私有构造函数
  DownLoadManage._() {
    // 具体初始化代码
  }

  // 静态、同步、私有访问点
  static DownLoadManage? _getInstance() {
    _instance ??= DownLoadManage._();
    return _instance;
  }

  /*
   *下载
   */
  Future download(url, savePath,
      {ProgressCallback? onReceiveProgress,
        ValueChanged<String>? done,
        ValueChanged? failed}) async {
    int downloadStart = 0;
    var saveFile = File(savePath);
    if(saveFile.existsSync()){
      done?.call(savePath);
      return;
    }
    bool fileExists = false;
    final String tempFile = savePath+ Md5Util.generateMd5(url);
    final File file = File(tempFile);
    if (await file.exists()) {
      downloadStart = file.lengthSync();
      fileExists = true;
    }
    debugPrint('download file $file ');
    debugPrint('开始：' + downloadStart.toString());
    if (fileExists && downloadingUrls.containsKey(url)) {
      debugPrint('已经在执行');
      return;
    }
    final dio = Dio();
    final int contentLength = await _getContentLength(dio, url,failed);
    if (downloadStart == contentLength) {//存在本地文件，命中缓存
      done!(tempFile);
      return;
    }
    final CancelToken cancelToken = CancelToken();
    downloadingUrls[url] = cancelToken;

    Future downloadByDio(String url, int start) async {
      try {
        final Response response = await dio.get(
          url,
          options: Options(
            responseType: ResponseType.stream,
            followRedirects: false,
            headers: {'range': 'bytes=$start-$contentLength'},
          ),
        );
        var raf = file.openSync(mode: FileMode.append);
        final Completer completer = Completer<Response>();
        int received = start;
        final int total = int.parse(response.headers
            .value(HttpHeaders.contentRangeHeader)!
            .split('/')
            .last);
        final Stream<List<int>> stream = response.data.stream;
        late StreamSubscription subscription;
        Future? asyncWrite;
        subscription = stream.listen(
              (data) {
            subscription.pause();
            asyncWrite = raf.writeFrom(data).then((_raf) {
              received += data.length;
              if (onReceiveProgress != null) {
                onReceiveProgress(received, total);
              }
              raf = _raf;
              if (!cancelToken.isCancelled) {
                subscription.resume();
              }
            });
          },
          onDone: () async {
            try {
              await asyncWrite;
              await raf.close();
              final saveFile = File(savePath);
              if(saveFile.existsSync()){
                saveFile.deleteSync();
              }
              file.renameSync(savePath);
              completer.complete(response);
              downloadingUrls.remove(url);
              if (done != null) {
                done(savePath);
              }
            } catch (e) {
              downloadingUrls.remove(url);
              if (failed != null) {
                failed(null);
              }
            }
          },
          onError: (e) async {
            try {
              await asyncWrite;
              await raf.close();
              downloadingUrls.remove(url);
              if (failed != null) {
                failed(null);
              }
            } finally {
            }
          },
          cancelOnError: true,
        );
        cancelToken.whenCancel.then((_) async {
          await subscription.cancel();
          await asyncWrite;
          await raf.close();
        });

        return null;
      } catch (e) {
        debugPrint('e = $e');
        if (failed != null) {
          failed(null);
        }
        downloadingUrls.remove(url);
      }
    }

    await downloadByDio(url, downloadStart);
  }

  /*
   * 获取下载的文件大小
   */
  Future _getContentLength(Dio dio, url, ValueChanged? failed) async {
    try {
      final Response response = await dio.get(url,options: Options(
        headers: {'range': 'bytes=0-102'},
      ),);
      debugPrint('response ${response.statusCode}');
      return int.parse(response.headers
          .value(HttpHeaders.contentRangeHeader)!
          .replaceAll('bytes ', '')
          .split('/')
          .last) ;
    } catch (e) {
      debugPrint('_getContentLength Failed:' + e.toString());
      if(failed != null){
        failed(null);
      }
      return 0;
    }
  }

  void stop(String? url) {
    if (downloadingUrls.containsKey(url)) {
      downloadingUrls[url!]!.cancel();
      downloadingUrls.remove(url);
    }
  }

}