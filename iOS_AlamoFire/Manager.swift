//
//  Manager.swift
//  iOS_AlamoFire
//
//  Created by imac on 28/11/2016.
//  Copyright © 2016 imac. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol ManagerDelegate {
    func postsGotten(manager:Manager, posts:[Post])
}

class Manager {
    var delegate:ManagerDelegate?
    private static var _instance:Manager?
    public static var instance:Manager {
        if Manager._instance == nil {
            Manager._instance = Manager()
        }
        return Manager._instance!
    }
    private init() {
    }
    private var _lastPosts:[Post] = []
    public func getLastPosts() -> [Post] {
        return _lastPosts
    }
    func getPosts(launchAfterUpdate:(() -> Void)?) {
        let url:String = "http://jsonplaceholder.typicode.com/posts"
        Alamofire.request(url).responseArray { (response: DataResponse<[Post]>) in
            if let postsResponse = response.result.value {
                self._lastPosts = postsResponse
                self.delegate?.postsGotten(manager: self, posts: self._lastPosts)
                if launchAfterUpdate != nil {
                    launchAfterUpdate!()
                }
            }
        }
    }
    func getPostsNoClosure() {
        let url:String = "http://jsonplaceholder.typicode.com/posts"
        Alamofire.request(url).responseArray { (response: DataResponse<[Post]>) in
            if let postsResponse = response.result.value {
                self._lastPosts = postsResponse
                self.delegate?.postsGotten(manager: self, posts: self._lastPosts)
            }
        }
    }
    func clearPosts() {
        _lastPosts = []
    }
    func getPost(at:Int) -> Post {
        if _lastPosts.count > at {
            return _lastPosts[at]
        } else {
            return Post()
        }
    }
    func removePost(at:Int) {
        let post = _lastPosts[at]
        let url:String = "http://jsonplaceholder.typicode.com/posts/\(post.id)"
        let _ = Alamofire.request(url, method: .delete)
        _lastPosts.remove(at: at)
    }
    func insertRandomPost() {
        let newPost:Post = Post()
        newPost.id = 1000
        newPost.body = "body"
        newPost.title = "title \(_lastPosts.count)"
        newPost.userId = 1
        _lastPosts.append(newPost)
        let url:String = "http://jsonplaceholder.typicode.com/posts/"
        let parameters: Parameters = ["id": newPost.id, "body": newPost.body, "title": newPost.title, "userId": newPost.userId]
        let _ = Alamofire.request(url, method:.post, parameters:parameters)
    }
}
