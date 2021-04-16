//
/*******************************************************************************
    Copyright © 2020 WhiteNoise. All rights reserved.

    File name:     DSDBHelper.swift
    Author:        Adrian

    Project name:  DeepSleep2

    Description:
    

    History:
            2020/7/9: File created.

********************************************************************************/
    

import UIKit
import SQLite

public struct DSFavoriteModel: Hashable, Codable {
    var id: Int64
    var name: String
    var updateTime: Int64
    var sounds: [FavoriteSound]?
    
    struct FavoriteSound: Hashable, Codable {
        var faovriteId: Int64
        var name: String
        var icon: String
        var remoteUrl: String
        var localUrl: String
        var volume: Double
    }
}

class DSDBHelper: NSObject {
    
    static let `default` = DSDBHelper()
    
    let historyId: Int64 = 111111111111
    
    var db: Connection?
    func prepareDB() {
        do {
            db = try Connection(dbPath())
            createTables()
        } catch {
            debugPrint("prepare database error: \(error)")
        }
        
    }
    
    fileprivate func dbPath() -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let documentPath = documentPaths.first ?? ""
        debugPrint("dbPath: \(documentPath)/DeepSleep2.sqlite")
        return "\(documentPath)/DeepSleep2.sqlite"
    }
    
    fileprivate func createTables() {
        createFavoriteTable()
        createFavoriteSoundsTable()
    }
}

extension DSDBHelper {
    
    /// 创建收藏列表 TABLE
    fileprivate func createFavoriteTable() {
        let table = Table("Favorites")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let updateDate = Expression<Int64>("update_date")
        do {
            try db?.run(table.create { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(updateDate)
            })
        } catch {
            debugPrint("dberror: create table failed. - \("Favorites")")
        }
    }
    
    /// 创建收藏的音频配置TABLE （对应的会有收藏列表的ID -> favorite_id）
    fileprivate func createFavoriteSoundsTable() {
        let table = Table("FavoriteSounds")
        // 收藏列表主键
        let favoriteId = Expression<Int64>("favorite_id")
        // sounds 名称
        let name = Expression<String?>("name")
        // Sounds icon
        let icon = Expression<String?>("icon")
        // Sounds remote url
        let remoteUrl = Expression<String?>("remote_url")
        // Sounds local url
        let localUrl = Expression<String?>("local_url")
        // Sounds volume
        let volume = Expression<Double?>("volume")
        do {
            try db?.run(table.create { t in
                t.column(favoriteId)
                t.column(name)
                t.column(icon)
                t.column(remoteUrl)
                t.column(localUrl)
                t.column(volume)
            })
        } catch {
            debugPrint("dberror: create table failed. - \("Favorites sounds")")
        }
    }
}

extension DSDBHelper {
    func deleteFavoirte(_ favoriteId: Int64) {
        deleteFavoriteListData(favoriteId)
        deleteFavoriteSoundsData(favoriteId)
    }
    
    fileprivate func deleteFavoriteListData(_ favoriteId: Int64) {
        let table = Table("Favorites")
        let db_favoriteId = Expression<Int64>("id")
        let alice = table.filter(db_favoriteId == favoriteId)
        
        do {
            try db?.run(alice.delete())
        } catch {
            debugPrint("dberror: delete table failed. - \("Favorites"):\(favoriteId)")
        }
    }
    
    fileprivate func deleteFavoriteSoundsData(_ favoriteId: Int64) {
        let table = Table("FavoriteSounds")
        let db_favoriteId = Expression<Int64>("favorite_id")
        let alice = table.filter(db_favoriteId == favoriteId)
        
        do {
            try db?.run(alice.delete())
        } catch {
            debugPrint("dberror: delete table failed. - \("Favorites sounds"):\(favoriteId)")
        }
    }
}

extension DSDBHelper {
    func loadAllFavorite(completion: (([DSFavoriteModel])->Void)?) {
        var favorites: [DSFavoriteModel] = []
        do {
            if let results = try db?.prepare("select * from Favorites ORDER BY update_date DESC;") {
                for row in results {
                    let favorite = DSFavoriteModel(id: row[0] as? Int64 ?? 0, name: row[1] as? String ?? "", updateTime: row[2] as? Int64 ?? 0)
                    favorites.append(favorite)
                }
            }
            loadAllFavoriteSounds(favorites: favorites, completion: completion)
            
        } catch {
            debugPrint("dberror: load favorites failed")
        }
    }
    
    func loadAllFavoriteSounds(favorites:[DSFavoriteModel], completion: (([DSFavoriteModel])->Void)?) {
        var resultsFavorites:[DSFavoriteModel] = []
        for favorite in favorites {
            var favorite = favorite
            var sounds: [DSFavoriteModel.FavoriteSound] = []
            do {
                if let results = try db?.prepare("select * from FavoriteSounds where favorite_id=\(favorite.id)") {
                    for row in results {
                        let sound = DSFavoriteModel.FavoriteSound(faovriteId: row[0] as? Int64 ?? 0, name: row[1] as? String ?? "", icon: row[2] as? String ?? "", remoteUrl: row[3] as? String ?? "", localUrl: row[4] as? String ?? "", volume: row[5] as? Double ?? 0.0)
                        sounds.append(sound)
                    }
                    favorite.sounds = sounds
                    resultsFavorites.append(favorite)
                }
            } catch {
                debugPrint("dberror: load favorites sounds failed")
            }
        }
        completion?(resultsFavorites)
    }
    
    func loadRecordLastHistorySounds(completion: ((_ sounds: [DSFavoriteModel.FavoriteSound])->Void)?) {
        
        var sounds: [DSFavoriteModel.FavoriteSound] = []
        do {
            if let results = try db?.prepare("select * from FavoriteSounds where favorite_id=\(historyId)") {
                for row in results {
                    let sound = DSFavoriteModel.FavoriteSound(faovriteId: row[0] as? Int64 ?? 0, name: row[1] as? String ?? "", icon: row[2] as? String ?? "", remoteUrl: row[3] as? String ?? "", localUrl: row[4] as? String ?? "", volume: row[5] as? Double ?? 0.0)
                    sounds.append(sound)
                }
            }
        } catch {
            debugPrint("dberror: load favorites sounds failed")
        }
        completion?(sounds)
    }
    
    
}

extension DSDBHelper {
    func addNewFavorite(favorite: DSFavoriteModel) {
        do {
            let stmtForFavorite = try db?.prepare("INSERT INTO Favorites (id,name,update_date) VALUES (?,?,?)")
            let stmtForSounds = try db?.prepare("INSERT INTO FavoriteSounds (favorite_id,name,icon,remote_url,local_url,volume) VALUES (?,?,?,?,?,?)")
            try stmtForFavorite?.run([favorite.id, favorite.name, favorite.updateTime])
            for sound in favorite.sounds ?? [] {
                try stmtForSounds?.run([favorite.id, sound.name, sound.icon, sound.remoteUrl, sound.localUrl, sound.volume])
            }
        } catch {
            debugPrint("dberror: insert fvavorite failed")
        }
    }
}

extension DSDBHelper {
    func recordLastHistorySounds(favorite: DSFavoriteModel) {
        do {
//            deleteFavoriteSoundsData()
            let table = Table("FavoriteSounds")
            let db_favoriteId = Expression<Int64>("favorite_id")
            let alice = table.filter(db_favoriteId == historyId)
            try db?.run(alice.delete())
            
            let stmtForSounds = try db?.prepare("INSERT OR REPLACE INTO FavoriteSounds (favorite_id,name,icon,remote_url,local_url,volume) VALUES (?,?,?,?,?,?)")
            
            for sound in favorite.sounds ?? [] {
                try stmtForSounds?.run([favorite.id, sound.name, sound.icon, sound.remoteUrl, sound.localUrl, sound.volume])
            }
        } catch {
            debugPrint("dberror: insert fvavorite failed")
        }
    }
}

extension DSDBHelper {
    func rename(favoriteId: Int64, name: String) {
        do {
            try db?.run("update Favorites set name=\"\(name)\" where id=\(favoriteId)")
        } catch {
            debugPrint("dberror: rename failed - \(favoriteId),error:\(error)")
        }
    }
}
