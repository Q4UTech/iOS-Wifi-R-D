//
//  SpeedTestThred.swift
//  VpnConnection
//
//  Created by gautam  on 16/06/23.
//

import Foundation


@available(iOS 13.0, *)
class SpeedTestThread:Thread{
    
    var vc:SpeedTestVC?=nil
    
    func setSpeedTestVC(_ vc:SpeedTestVC){
        self.vc=vc;
    }
    
    override func main() {
        vc?.checkDownloadSpeed()
    }
}
