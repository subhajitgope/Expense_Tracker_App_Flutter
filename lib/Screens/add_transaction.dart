import 'dart:ffi';
import 'dart:math';

import 'package:expense_tracker_app_flutter/controllers/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  //
  int? amount;
  String note="Breakfast";
  String type="Income";
  DateTime selectedDate=DateTime.now();
  List<String> months=["January","February","March","April","May","June","July","August","September","October","November","December"];




  //
  Future<void> _selectDate(BuildContext context) async{
    final DateTime? picked=await showDatePicker(context: context,initialDate: selectedDate, firstDate: DateTime(2020,12), lastDate: DateTime(2100,01),);
  if(picked != null && picked!=selectedDate){
    setState(() {
      selectedDate=picked;
    });
  }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text("Add Transaction",
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Amount",
             // hintText: "00.00",
              prefixIcon: Icon(Icons.attach_money,color: Colors.purple,),
            ),
            style: TextStyle(fontSize: 20.0),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
            onChanged: (val){
              try{
                amount=int.parse(val);
              }catch(e){
                
              }
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Description",
              // hintText: "00.00",
              prefixIcon: Icon(Icons.description,color: Colors.purple,),
            ),
            style: TextStyle(fontSize: 20.0,),maxLength: 10,showCursor: true,
            inputFormatters: [
              FilteringTextInputFormatter.singleLineFormatter,
            ],
            keyboardType: TextInputType.text,
            onChanged: (val){
              note=val;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0),


                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Icon(Icons.whatshot,color: Colors.purple,),
              ),
              SizedBox(width: 12.0,),
             ChoiceChip(label: Text("Income",style: TextStyle(
               fontSize: 15.0,color: type=="Income" ? Colors.white : Colors.green,
             ),), selected: type=="Income" ? true : false,
             onSelected: (val){
               if(val){
                 setState(() {
                   type="Income";
                 });
               }
    },
             ),

              SizedBox(width: 12.0,),
              ChoiceChip(label: Text("Expense",style: TextStyle(
                fontSize: 15.0,color: type=="Expense" ? Colors.white : Colors.green,
              ),), selected: type=="Expense" ? true : false,
                onSelected: (val){
                  if(val){
                    setState(() {
                      type="Expense";
                    });
                  }
                },
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 50.0,
            child: TextButton(
              onPressed: (){
                _selectDate(context);
              },
              child: Row(
                children: [
                  Icon(Icons.date_range,color: Colors.purple,),
                  SizedBox(
                    width: 12.0,
                  ),
                  Text("${selectedDate.day} ${months[selectedDate.month-1]}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

              ),


          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 50.0,
            child: ElevatedButton(
                onPressed: () async {
                 if(amount != null && note.isNotEmpty){
                    DbHelper dbHelper=DbHelper();
                    dbHelper.addData(amount!, selectedDate, note, type);
                Navigator.of(context).pop();
                 }else{
                   print("Not All Value Added");
                 }

                }, child: Text("Add",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w600),)),
          ),
        ],

      ),
    );
  }
}

