//
//  Movie.swift
//  AI2020OS
//
//  Created by tinkl on 2/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import JSONJoy

/*!
*  @author tinkl, 15-04-23 11:04:05
*
*  The first function will take an Array with JSON values and map it using the second function
*/
struct MovieReponse {
    let page: Int?
    var results: Array<Movie>?
    init() {
    }
    init(_ decoder: NSDictionary) {
        self.page = decoder["page"] as? Int ?? 0
        //decoder.getArray(&results) //pass the optional array by reference, it will be allocated if it is not and filled
        let unparsedComments = decoder["results"] as? [NSDictionary] ?? []
        let parsedComments = unparsedComments.map(flattenedComments)
        let flattenedParsedComments = parsedComments.reduce([], +)
        results  = flattenedParsedComments
    }
}

private func flattenedComments(comment: NSDictionary) -> [Movie] {
    // comment is JSON string....
    let comments = comment["results"] as? [NSDictionary] ?? []
    
    return comments.reduce([Movie(comment)]) { acc, x in
        acc + flattenedComments(x)
    }
}

struct Movie{
    
    let id: Int?
    let title: String?
    let original_title: String?
    let backdrop_path: String?
    let poster_path: String?
    let release_date: String?
    
    init() {
        
    }
    
    init(_ decoder: NSDictionary) {
        self.id = decoder["id"] as? Int ?? 0
        self.title = decoder["title"]  as? String ?? ""
        self.original_title = decoder["original_title"] as? String ?? ""
        let b_path = decoder["backdrop_path"] as? String ?? ""
        self.backdrop_path = "http://image.tmdb.org/t/p/w780/" + b_path
        self.poster_path = decoder["poster_path"] as? String ?? ""
        self.release_date = decoder["release_date"] as? String ?? ""
    }
}

struct AIKMMovie {
    let movieId: String?
    let movieTitle: String?
    let movieSynopsis: String?
    let movieYear: String?
    let movieOriginalBackdropImageUrl: String?
    let movieOriginalPosterImageUrl: String?
    let movieThumbnailPosterImageUrl: String?
    let movieThumbnailBackdropImageUrl: String?
    let movieGenresString: String?
    let movieVoteCount: String?
    let movieVoteAverage: String?
    let moviePopularity: String?
    let movieOverview: String?
    var moviePCompanies: Array<PCompanies>?
    
    init() {
        
    }
    
    init(_ decoder: NSDictionary) {
        self.movieId = decoder["id"] as? String ?? ""
        self.movieTitle = decoder["title"]  as? String ?? ""
        self.movieSynopsis = decoder["tagline"] as? String ?? ""
        self.movieYear = decoder["release_date"] as? String ?? ""
        self.movieGenresString = decoder["overview"] as? String ?? ""
        self.movieVoteCount = decoder["vote_count"] as? String ?? ""
        self.movieVoteAverage = decoder["vote_average"] as? String ?? ""
        self.moviePopularity = decoder["popularity"] as? String ?? ""
        self.movieOverview = decoder["overview"] as? String ?? ""
        let b_path = decoder["backdrop_path"] as? String ?? ""
        self.movieOriginalBackdropImageUrl = "http://image.tmdb.org/t/p/w300/" + b_path

        let p_path = decoder["poster_path"] as? String ?? ""
        self.movieOriginalPosterImageUrl = "http://image.tmdb.org/t/p/w780/" + p_path
        
        self.movieThumbnailBackdropImageUrl = "http://image.tmdb.org/t/p/w92/" + b_path
        self.movieThumbnailPosterImageUrl = "http://image.tmdb.org/t/p/w92/" + p_path
     
        
        let unparsedComments = decoder["production_companies"] as? [NSDictionary] ?? []
        let parsedComments = unparsedComments.map(flattenedPCompanies)
        let flattenedParsedComments = parsedComments.reduce([], +)
        self.moviePCompanies  = flattenedParsedComments
        
    }
}

private func flattenedPCompanies (comment: NSDictionary) -> [PCompanies] {
    // comment is JSON string....
    let comments = comment["production_companies"] as? [NSDictionary] ?? []
    
    return comments.reduce([PCompanies(comment)]) { acc, x in
        acc + flattenedPCompanies(x)
    }
}



struct PCompanies{
    
    let pcId: String?
    let pcName: String?
    init() {
        
    }
    
    init(_ decoder: NSDictionary) {
        self.pcId = decoder["id"] as? String ?? ""
        self.pcName = decoder["name"]  as? String ?? ""
    }
}



