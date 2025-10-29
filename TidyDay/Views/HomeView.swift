import SwiftUI

struct HomeView: View {
    @State private var selectedDate = Date()
    @State private var showingSearch = false
    @State private var showingNotifications = false
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let weekDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    // Greeting
                    VStack(alignment: .leading) {
                        Text("Hello")
                            .font(.title)
                            .foregroundColor(.gray)
                        Text("User 👋")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    // Action Buttons
                    HStack(spacing: 20) {
                        Button(action: { showingSearch = true }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: { showingNotifications = true }) {
                            Image(systemName: "bell")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                // Date Selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(-2...2, id: \.self) { offset in
                            let date = calendar.date(byAdding: .day, value: offset, to: selectedDate) ?? selectedDate
                            DateButton(date: date,
                                     isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                     action: { selectedDate = date })
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Tasks counter
                Text("6 Tasks Today")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

struct DateButton: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let weekDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(weekDayFormatter.string(from: date))
                    .font(.subheadline)
                    .foregroundColor(isSelected ? .white : .gray)
                Text(dateFormatter.string(from: date))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 80, height: 80)
            .background(isSelected ? Color.blue.opacity(0.8) : Color.gray.opacity(0.1))
            .cornerRadius(20)
        }
    }
}

#Preview {
    HomeView()
}