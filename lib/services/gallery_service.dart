import 'package:photo_manager/photo_manager.dart';

import '../core/utils/logger.dart';

class GalleryService {
  Future<bool> requestPermission() async {
    Log.i('🖼️ [Gallery] 권한 요청 시작');

    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();

    if (permission.isAuth) {
      Log.i('✅ [Gallery] 권한 허용됨');
      return true;
    }

    if (permission.hasAccess) {
      Log.w('⚠️ [Gallery] 제한된 접근 권한');
      return true;
    }

    Log.w('⚠️ [Gallery] 권한 거부됨');
    return false;
  }

  Future<List<AssetEntity>> loadScreenshots({int page = 0, int size = 50}) async {
    Log.i('🖼️ [Gallery] 스크린샷 로드 시작 | page: $page, size: $size');

    try {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(ignoreSize: true),
          ),
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false),
          ],
        ),
      );

      if (albums.isEmpty) {
        Log.w('⚠️ [Gallery] 앨범 없음');
        return [];
      }

      // Find Screenshots album or use first album (All Photos)
      AssetPathEntity targetAlbum = albums.first;
      for (final album in albums) {
        if (album.name.toLowerCase().contains('screenshot')) {
          targetAlbum = album;
          Log.d('📱 [Gallery] Screenshots 앨범 발견 | name: ${album.name}');
          break;
        }
      }

      final List<AssetEntity> assets = await targetAlbum.getAssetListPaged(
        page: page,
        size: size,
      );

      Log.i('✅ [Gallery] 스크린샷 로드 완료 | count: ${assets.length}');
      return assets;
    } catch (e, s) {
      Log.e('❌ [Gallery] 스크린샷 로드 실패', e, s);
      rethrow;
    }
  }

  Future<int> getTotalCount() async {
    try {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albums.isEmpty) return 0;

      // Find Screenshots album or use first album
      AssetPathEntity targetAlbum = albums.first;
      for (final album in albums) {
        if (album.name.toLowerCase().contains('screenshot')) {
          targetAlbum = album;
          break;
        }
      }

      return await targetAlbum.assetCountAsync;
    } catch (e, s) {
      Log.e('❌ [Gallery] 총 개수 조회 실패', e, s);
      return 0;
    }
  }
}
