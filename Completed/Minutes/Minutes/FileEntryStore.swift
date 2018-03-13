import Foundation

class FileEntryStore
{
    func read() -> [Entry]
    {
        var entries = [Entry]()
        
        do
        {
            let baseUrl: URL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let fileUrls: [URL] = try FileManager.default.contentsOfDirectory(at: baseUrl, includingPropertiesForKeys: [], options: [.skipsHiddenFiles])
            
            for fileUrl: URL in fileUrls
            {
                let data = try Data(contentsOf: fileUrl)
                
                let entry = FileEntryStore.deserialize(data)
                
                entries.append(entry!)
            }
        }
        catch
        {
            // Suppress error to keep sample code simple
        }
        
        return entries
    }
    
    func write(_ entry: Entry)
    {
        do
        {
            let baseUrl: URL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let fileUrl = baseUrl.appendingPathComponent(entry.id)
            
            let data: Data = FileEntryStore.serialize(entry)!
            
            try data.write(to: fileUrl)
        }
        catch
        {
            // Suppress error to keep sample code simple
        }
    }
    
    func delete(_ entry: Entry)
    {
        do
        {
            let baseUrl: URL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let fileUrl = baseUrl.appendingPathComponent(entry.id)

            try FileManager.default.removeItem(at: fileUrl)
        }
        catch
        {
            // Suppress error to keep sample code simple
        }
    }
    
    static func serialize(_ entry: Entry) -> Data?
    {
        if let data = try? JSONEncoder().encode(entry) { return data }
        
        return nil
    }
    
    static func deserialize(_ data: Data) -> Entry?
    {
        if let entry = try? JSONDecoder().decode(Entry.self, from: data) { return entry }
        
        return nil
    }
}
