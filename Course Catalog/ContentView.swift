//
//  ContentView.swift
//  Course Catalog
//
//  Created by Jackson Hardy on 6/15/24.
//

import SwiftUI



struct ContentView: View {
    @State private var showOnlySelected = false
    @State private var coursesDict: [String: [String: String]] = [:]
    @State private var selectedCourses: Set<String> = []
    /*
     the init() function is only called once before the view is displayed
     the first time and is a convenient place in the app logic to populate
     coursesDict by calling loadCSCourses()
     */
    init() {
        self._coursesDict = State(initialValue: [:])
        self._selectedCourses = State(initialValue: [])
        loadCSCourses()
    }
    
    var body: some View {
        VStack {
            Text("Course Catalog")
                .font(.largeTitle)
                .padding()
                .accessibilityIdentifier("title")
            
            List {
                ForEach(sortedKeys(), id: \.self) { key in
                    if !showOnlySelected || selectedCourses.contains(key) {
                        CourseRow(courseNumber: key,
                                  courseDescription: coursesDict[key]?["ShortDescription"] ?? "",
                                  isSelected: selectedCourses.contains(key))
                            .onTapGesture {
                                toggleSelection(course: key)
                            }
                    }
                }
            }

            HStack {
                Toggle("Show Only Selected Courses", isOn: $showOnlySelected)
                    .toggleStyle(.button)
                    .accessibilityIdentifier("showOnlySelectedCoursesSwitch")
                    .padding(10)
                    .onChange(of:showOnlySelected) {value in
                        print("Toggle switched to: \(value)")
                        print("Currently selected courses: \(selectedCourses)")
                    }
            }
        }
        .onAppear {
            loadCSCourses()
        }
    }

    func sortedKeys() -> [String] {
        return Array(coursesDict.keys).sorted().filter { !showOnlySelected || selectedCourses.contains($0) }
    }

    func toggleSelection(course: String) {
        if selectedCourses.contains(course) {
            selectedCourses.remove(course)
        } else {
            selectedCourses.insert(course)
        }
        print("Selected courses after toggle: \(selectedCourses)")
    }


    func loadCSCourses() {
        if let path = Bundle.main.path(forResource: "CSCourses", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: [String: String]] {
            coursesDict = dict
            print("Loaded courses: \(coursesDict)") 
        } else {
            print("Failed to load CSCourses.plist")
        }
    }
}

struct CourseRow: View {
    var courseNumber: String
    var courseDescription: String
    var isSelected: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(courseNumber)
                    .font(.title3)
                Text(courseDescription)
                    .font(.subheadline)
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.square")
                    .resizable()
                    .frame(width: 32.0, height: 32.0)
                    .accessibilityLabel("ischecked")
            } else {
                Image(systemName: "square")
                    .resizable()
                    .frame(width: 32.0, height: 32.0)
                    .accessibilityLabel("unchecked")
            }
        }
        .padding(1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
