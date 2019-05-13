//
//  FileManager.swift
//  PretRecommendations
//
//  Created by Sean Orelli on 5/10/19.
//  Copyright © 2019 Fuzz Productions. All rights reserved.
//

import UIKit


extension FileManager
{
    static func documents() -> String
    {
        return FileManager.documentsURL().relativeString
    }
    
    static func documentsURL() -> URL
    {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static func contents(directory:URL) -> [URL]
    {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: FileManager.documentsURL(), includingPropertiesForKeys: nil)
            return fileURLs
            // process files
        } catch {
            print("Error while enumerating files: \(error.localizedDescription)")
        }
        
        return []
    }
}
