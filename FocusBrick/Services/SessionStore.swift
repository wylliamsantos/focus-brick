import Foundation

protocol SessionStore {
    func save(record: SessionRecord)
    func loadAll() -> [SessionRecord]
}
