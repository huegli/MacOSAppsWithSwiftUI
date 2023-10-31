//
//  ContentView.swift
//  notetaking
//
//  Created by Nikolai Schlegel on 10/25/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \NoteEntry.createdAt, ascending: true)],
        animation: .default)
    private var noteEntries: FetchedResults<NoteEntry>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(noteEntries) { noteEntry in
                    NoteEntryView(noteEntry: noteEntry)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: PersistenceController.shared.addNoteEntry) {
                        Label("Add Note", systemImage: "plus")
                    }
                }
            }
            Text("Select a note")
        }
    }
}

struct NoteEntryView: View {
    @ObservedObject var noteEntry: NoteEntry
    
    /// Define states to store values of the text inputs
    @State private var titleInput:  String = ""
    @State private var contentInput: String = ""
    @State private var shouldShowDeleteButton: Bool = false
    @State private var shouldPresentConfirm: Bool = false
    
    var body: some View {
        if let title = noteEntry.title,
           let content = noteEntry.content,
           let updatedAt = noteEntry.updatedAt {
            NavigationLink {
                VStack {
                    /// Text field for Title, One-line Text Input,
                    TextField("Title", text: $titleInput)
                    /// When the view is rendered, assuming the FetchRequest is finished
                    /// update the text input with the fetched result.
                        .onAppear() {
                            self.titleInput = title
                        }
                        .onChange(of: titleInput) { newTitle in
                            PersistenceController.shared.updateNoteEntry(noteEntry: noteEntry, title: newTitle, content: contentInput)
                        }
                    /// Text Editor for Content. Multi-line Text Input.
                    TextEditor(text: $contentInput)
                        .onAppear() {
                            self.contentInput = content
                        }
                        .onChange(of: contentInput) { newContent in
                            PersistenceController.shared.updateNoteEntry(noteEntry: noteEntry, title: titleInput, content: newContent)
                        }
                }
            } label: {
                HStack {
                    Text(title)
                    Text(updatedAt, formatter: itemFormatter)
                    Spacer()
                    if shouldShowDeleteButton || shouldPresentConfirm {
                        Button {
                            shouldPresentConfirm = true
                        } label: {
                            Image(systemName: "minus.circle")
                        }.buttonStyle(.plain)
                            .confirmationDialog("Are you sure?", isPresented: $shouldPresentConfirm) {
                                Button("Delete this note", role:.destructive) {
                                    PersistenceController.shared.deleteNoteEntry(noteEntry: noteEntry)
                                }
                            }
                    }
                }.onHover { isHover in
                    shouldShowDeleteButton = isHover
                }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
