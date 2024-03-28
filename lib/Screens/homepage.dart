

import 'package:expense_tracker_app_flutter/Screens/add_transaction.dart';
import 'package:expense_tracker_app_flutter/controllers/db_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DbHelper dbHelper=DbHelper();
  DateTime today=DateTime.now();
  int totalBalance=0;
  int totalIncome=0;
  int totalExpense=0;


  getTotalBalance  (Map entireData){
    totalExpense = 0;

    totalIncome = 0;
    totalBalance = 0;
    entireData.forEach((key, value) {



if(value['type']=="Income"){
  totalBalance += (value['amount'] as int);

  totalIncome += (value['amount'] as int);
}else{
  totalBalance -= (value['amount'] as int);
  totalExpense += (value['amount'] as int);
}

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTransaction(),),
             )
             .whenComplete((){
               setState(() {});
            });
          },
          backgroundColor: Colors.greenAccent,
          shape:  BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Icon(Icons.add_box,size: 30.0,), ),
      ),
      body: FutureBuilder<Map>(
        future: dbHelper.fetch(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(child: Text("Unexpected Error"),);
          }
          if(snapshot.hasData){
            if(snapshot.data!.isEmpty){
              return Center(child: Text("No values found"),
              );
            }
            getTotalBalance(snapshot.data!);
            return ListView(
              children: [
               Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Container(width: 50.0,height: 50.0,
                             decoration:BoxDecoration(
                               borderRadius: BorderRadius.circular(32.0),color: Colors.white70,
                             ),child: CircleAvatar(maxRadius: 32.0,child: Image(image: AssetImage("images/smiley.png"),width: 34.0,)),
                         ),
                         SizedBox(
                           width: 8.0,
                         ),
                         Text("Welcome Subhajit!",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25.0),),
                       ],
                     ),
                     Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: Container(
                           decoration:BoxDecoration(
                             borderRadius: BorderRadius.circular(12.0),color: Colors.white70,
                           ),child: Icon(Icons.notifications,size: 32.0,color: Colors.blueGrey,)
                       ),
                     ),
                   ],
                 ),
               ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple,
                          Colors.blueAccent,
                        ]
                      ),
                      borderRadius:  BorderRadius.all(
                        Radius.circular(24.0),
                      )
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 8.0),
                    child: Column(
                      children: [
                        Text("Total Balance",textAlign:TextAlign.center,style: TextStyle(fontSize: 20.0,color: Colors.white),),SizedBox(height: 12.0,),
                        Text("RS $totalBalance",textAlign:TextAlign.center,style: TextStyle(fontSize: 23.0,color: Colors.white,fontWeight: FontWeight.w700),),SizedBox(
                          height: 12.0,
                        ),
                        Padding(padding: EdgeInsets.all(8.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cardIncome(totalIncome.toString()),
                            cardExpense(totalExpense.toString()),
                          ],
                        ),),
                      ],
                    ),
                  ),
                ),Padding(padding: EdgeInsets.all(12.0),
                child: Text("Expenses",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w900,color: Colors.black87),),),
Container(
  height: 300,
  padding: EdgeInsets.symmetric(
    vertical: 40.0,
    horizontal: 12.0,
  ),
  margin: EdgeInsets.all(
    12.0,
  ),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(8),
      bottomLeft: Radius.circular(8),
      bottomRight: Radius.circular(8),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset:
        Offset(0, 3), // changes position of shadow
      ),
    ],
  ),
  child: LineChart(
LineChartData(
borderData: FlBorderData(
    show: false,
  ),
  lineBarsData: [
LineChartBarData(
spots: [
  FlSpot(1, 3),
  FlSpot(2, 5),
  FlSpot(3, 4),
  FlSpot(4, 8),
],
  isCurved: false,
  barWidth: 2.5,
  color:
    Colors.blueAccent,

)
  ]
)
  ),
),
Padding(padding: EdgeInsets.all(12.0),
child: Text("Recent Expenses",style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w900,color: Colors.black87)),),
                ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),itemCount: snapshot.data!.length,itemBuilder: (context,index){
                  Map dataAtIndex=snapshot.data![index];
                  if(dataAtIndex['type']=="Expense"){
                    return expenseTile(dataAtIndex['amount'], dataAtIndex['note']);

                  }else{
                    return incomeTile(dataAtIndex['amount'], dataAtIndex['note']);
                  }

                },
                ),
              ],
            );

          }
          else{
            return Center(child: Text("Unexpected Error"),);
          }
        },
      )
    );
  }
  Widget cardIncome(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.all(6.0),
          child: Icon(Icons.arrow_downward,
          size: 27.0,color: Colors.green[700],),
margin: EdgeInsets.only(right: 8.0),

        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Income",style: TextStyle(fontSize: 17,color: Colors.white70,),),
            Text(value,style: TextStyle(fontSize: 20,color: Colors.white70,fontWeight: FontWeight.w700),),
          ],
        )
      ],
    );
  }
  Widget cardExpense(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.all(6.0),
          child: Icon(Icons.arrow_upward,
            size: 27.0,color: Colors.red[700],),
          margin: EdgeInsets.only(right: 8.0),

        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Expense",style: TextStyle(fontSize: 17,color: Colors.white70,),),
            Text(value,style: TextStyle(fontSize: 20,color: Colors.white70,fontWeight: FontWeight.w700),),
          ],
        )
      ],
    );
  }
  Widget expenseTile(int value,String note){
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(color: Color(0xffced4eb),borderRadius: BorderRadius.circular(8.0)
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon((Icons.arrow_circle_up_outlined),color: Colors.red[700],size: 25.0
              ),
              SizedBox(
                width: 4.0,
              ),
              Text("Expense",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w700),
              ),
            ],

          ),
          Text("- $value",style: TextStyle(
            fontWeight: FontWeight.w700,fontSize: 20.0
          ),)
        ],
      ),
    );
  }
  Widget incomeTile(int value,String note){
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(color: Color(0xffced4eb),borderRadius: BorderRadius.circular(8.0)
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon((Icons.arrow_circle_down_outlined),color: Colors.green[700],size: 25.0
              ),
              SizedBox(
                width: 4.0,
              ),
              Text("Income",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w700),
              ),
            ],

          ),
          Text("+ $value",style: TextStyle(
              fontWeight: FontWeight.w700,fontSize: 20.0
          ),)
        ],
      ),
    );
  }
}


