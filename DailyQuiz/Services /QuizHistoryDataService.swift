//
//  QuizHistoryDataService.swift
//  DailyQuiz
//
//  Created by Denis Shabanov on 03.08.2025.
//

import Foundation
import CoreData

final class QuizHistoryDataService {
    
    static let shared = QuizHistoryDataService()
    
    private let container: NSPersistentContainer
    private let containerName: String = "QuizHistoryEntity"
    private let entityName: String = "HistoryEntity"
    
    let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка загрузки хранилища Core Data: \(error)")
            }
        }
        context = container.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения контекста: \(error)")
            }
        }
    }
    
    func deleteQuiz(with id: UUID) {
        let request: NSFetchRequest<HistoryEntity> = HistoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            if let entityToDelete = try context.fetch(request).first {
                context.delete(entityToDelete)
                saveContext()
            }
        } catch {
            print("Ошибка удаления викторины: \(error)")
        }
    }
    
    func fetchAllHistory() -> [HistoryEntity] {
        let request: NSFetchRequest<HistoryEntity> = HistoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HistoryEntity.date, ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка загрузки истории из Core Data: \(error)")
            return []
        }
    }
    
}
