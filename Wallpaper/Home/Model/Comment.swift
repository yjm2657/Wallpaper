//
//    Comment.swift
//
//    Create by 洁茂 杨 on 26/6/2018
//    Copyright © 2018. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import HandyJSON

class Comment : HandyJSON{
    
    var atime : Int!
    var content : String!
    var id : String!
    var isup : Bool!
    var replyMeta : CommentReplyMeta!
    var replyUser : CommentReplyMeta!
    var size : Int!
    var user : CommentUser!
    required init(){}
    
}
