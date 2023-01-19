//
//  ContentView.swift
//  MPOO_FinalProject
//
//  Created by Alan Carrasco on 08/01/23.
//

import SwiftUI
import UserNotifications

//MARK: Pomodoro Timer View
struct PomodoroTimerView: View {
    
    @StateObject private var conteo = ViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var showingAlert = false
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var chartData: FetchedResults<ChartData>
    
    @State var minutesFocused = 0
    
    let defaults = UserDefaults.standard
    
    var body: some View {
        //NavigationView controla los cambios entre vistas
        NavigationView{
            
            VStack{
                // Texto que muestra los minutos y los segundos
                Text("\(conteo.time)")
                    .font(.system(size: 70, weight: .medium, design: .serif))
                    .padding()
                    .frame(width: 250, height: 250)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 3))
                
                    .alert("Sesión completada", isPresented: $conteo.showingAlert){
                        Button("Continuar", role: .cancel){
                            conteo.reset()
                            saveChartData(minutesFocused: minutesFocused)
                        }
                    }
                // Slider que controla el número de minutos del timer
                Slider(value: $conteo.minutes, in: 10...60, step: 5)
                    .padding()
                    .frame(width: 250)
                    .disabled(conteo.isActive)
                    .animation(.easeInOut, value: conteo.minutes)
                
                HStack(spacing: 6){
                    Button("Iniciar"){
                        conteo.start(minutes: conteo.minutes)
                        minutesFocused = Int(conteo.minutes)
                    }
                    .font(.system(.body,design: .serif))
                    .frame(width: 122, height: 50)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(conteo.isActive)
                    
                    Button("Reiniciar", action: conteo.reset)
                        .font(.system(.body,design: .serif))
                        .tint(.red)
                        .frame(width: 122, height: 50)
                        .background(Color.white)
                        .foregroundColor(.red)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                        .disabled(conteo.isActive)
                    
                }
                .frame(width: 250)
                
                Button("Rendirse"){
                    showingAlert = true
                }
                .font(.system(.body,design: .serif))
                .frame(width: 250, height: 50)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
                .alert(isPresented: $showingAlert){
                    Alert(
                        title: Text("Atención"),
                        message: Text("¿Estás seguro que quieres rendirte?"),
                        primaryButton: .destructive(Text("Cancelar")),
                        secondaryButton: .default(Text("Rendirse"), action: conteo.reset)
                    )
                }
                .disabled(!conteo.isActive)
                
                // NavigationLink es el botón que te lleva a la otra vista
                NavigationLink(
                    destination: StatsView(),
                    label: {
                        Text("Stats")
                            .bold()
                            .frame(width: 250, height: 50)
                            .font(.system(.body, design: .serif))
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                .disabled(conteo.isActive)
            }
            .navigationTitle("Real Focus")
            .onAppear(perform: {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { _, _ in
                }
            })
            .onReceive(timer) { _ in
                if conteo.isActive{
                    conteo.updateCountdown()
                }
                
            }
        }
        //bracket de cierre de NavigationView
        .accentColor(Color(.label))
    }

    func saveChartData(minutesFocused: Int) {
        let sesion = ChartData(context: moc)
        sesion.id = UUID()
        sesion.date = Date()
        sesion.minutesCount = Int16(minutesFocused)
        try? moc.save()
        //chartData[month-1].minutesCount += minutesFocused
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
    }
}

