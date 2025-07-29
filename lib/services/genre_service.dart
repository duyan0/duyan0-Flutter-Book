import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/genre.dart';
import 'base_api_service.dart';

class GenreService extends BaseApiService {
  GenreService() : super();
  
  Future<Map<String, dynamic>> getGenres({
    int page = 1,
    int pageSize = 10,
    String? searchTerm,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      
      if (searchTerm != null && searchTerm.isNotEmpty) {
        queryParams['search'] = searchTerm;
      }

      final response = await httpGet('/TheLoai', queryParams: queryParams);
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true && 
            jsonResponse['data'] != null && 
            jsonResponse['data']['items'] != null &&
            jsonResponse['data']['items']['\$values'] != null) {
          
          final List<dynamic> genreData = jsonResponse['data']['items']['\$values'];
          final List<Genre> genres = genreData.map((item) => Genre.fromJson(item)).toList();
          
          final pagination = jsonResponse['data']['pagination'];
          
          return {
            'genres': genres,
            'pagination': pagination,
          };
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load genres: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting genres: $e');
      rethrow;
    }
  }

  Future<Genre> getGenreById(int id) async {
    try {
      final response = await httpGet('/TheLoai/$id');
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return Genre.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load genre: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting genre by id: $e');
      rethrow;
    }
  }

  Future<Genre> createGenre(String tenTheLoai, {String? moTa}) async {
    try {
      final body = {
        'tenTheLoai': tenTheLoai,
        'moTa': moTa,
        'trangThai': true,
      };
      
      final response = await httpPost('/TheLoai', body);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return Genre.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to create genre: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error creating genre: $e');
      rethrow;
    }
  }

  Future<Genre> updateGenre(int id, String tenTheLoai, {String? moTa, bool? trangThai}) async {
    try {
      final body = {
        'maTheLoai': id,
        'tenTheLoai': tenTheLoai,
        'moTa': moTa,
        'trangThai': trangThai ?? true,
      };
      
      final response = await httpPut('/TheLoai/$id', body);
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return Genre.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to update genre: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating genre: $e');
      rethrow;
    }
  }

  Future<bool> deleteGenre(int id) async {
    try {
      final response = await httpDelete('/TheLoai/$id');
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['success'] == true;
      } else {
        throw Exception('Failed to delete genre: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error deleting genre: $e');
      rethrow;
    }
  }
} 