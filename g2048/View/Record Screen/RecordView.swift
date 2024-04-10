import SwiftUI

/// Main menu View.
struct RecordView: View {
    /// Loads all records from CoreData.
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.score, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Record>

    /// Scene switcher.
    @Binding var selectedScene: AppScene

    /// Main menu body.
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Scores")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("BoardDark"))
                List {
                    if items.count > 0 {
                        ForEach(items, id: \.self) { record in
                            HStack {
                                Text("\(record.score)")
                                Spacer()
                                Text("\(record.timestamp?.formatted() ?? "")")
                            }
                        }
                    } else {
                        Text("No records here...")
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color("Background"))
            }
            .onSwipe { gesture in
                if gesture.translation.width > 0 {
                    selectedScene = .mainMenu
                }
            }
        }
    }
}

/// Main menu view editor preview.
struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(selectedScene: .constant(.highScores))
            .environment(\.managedObjectContext,
                RecordPersistence.preview.container.viewContext)
    }
}
