import Foundation

class Reflect: NSObject, NSCoding{
    
    lazy var mirror: MirrorType = {reflect(self)}()

    required override init(){}
    
    required convenience init(coder aDecoder: NSCoder) {
        
        self.init()
        
        let ignorePropertiesForCoding = self.ignoreCodingPropertiesForCoding()
        
        self.properties { (name, type, value) -> Void in
             assert(type.check(), "[Charlin Feng]: Property '\(name)' type can not be a '\(type.realType.rawValue)' Type,Please use 'NSNumber' instead!")
            
            let hasValue = ignorePropertiesForCoding != nil

            if hasValue {
                
                let ignore = contains(ignorePropertiesForCoding!, name)
                
                if !ignore {
                
                    self.setValue(aDecoder.decodeObjectForKey(name), forKeyPath: name)
                }
            }else{
                self.setValue(aDecoder.decodeObjectForKey(name), forKeyPath: name)
            }
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        let ignorePropertiesForCoding = self.ignoreCodingPropertiesForCoding()
        
        self.properties { (name, type, value) -> Void in
            
            let hasValue = ignorePropertiesForCoding != nil
            
            if hasValue {
                
                let ignore = contains(ignorePropertiesForCoding!, name)
                
                if !ignore {
                    
                    aCoder.encodeObject(value as? AnyObject, forKey: name)
                }
            }else{
                aCoder.encodeObject(value as? AnyObject, forKey: name)
            }
            
        }
        
    }
    
    
}



