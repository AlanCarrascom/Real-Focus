//
//  StatsView.swift
//  Real Focus
//
//  Created by Alan Carrasco on 18/01/23.
//

import SwiftUI
import Charts



struct StatsView: View {
    
    @FetchRequest(sortDescriptors: []) var chartData: FetchedResults<ChartData>
    let meses = [1,2,3,4,5,6,7,8,9,10,11,12]
    let nombresMeses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
    
    var body: some View {
        VStack{
            Text("Minutos concentrado")
                .font(.title)
                .bold()
                .fontWeight(.medium)
            Text("Aquí verás tu progreso respecto al tiempo.")
                .font(.caption)
                .fontWeight(.thin)
            Chart{
                ForEach(chartData){ ChartData in
                    BarMark(x: .value("Mes", ChartData.date ?? Date(), unit: .year),
                        y: .value("Minutos", ChartData.minutesCount))
                }
                .foregroundStyle(Color.pink.gradient)
            }
            .padding()
            .frame(height: 230)
            .chartYScale(domain: 0...240)
        }
        .navigationTitle("Stats")
        .offset(y: -60)
        
        
/*            Chart{
                ForEach(chartData){ chartData in
                    BarMark(x: .value("Mes", chartData.date, unit: .month),y: .value("Minutos", chartData.minutesCount))
                }
                
            }
            

*/
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
