//
//  InformacoesPesquisa.swift
//  testefastshop
//
//  Created by Gabriel Sousa Leal on 05/12/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation

struct InformacoesPesquisa: Decodable {
    
    let total_pages: Int
    let total_results: Int
    let page: Int
    
}
