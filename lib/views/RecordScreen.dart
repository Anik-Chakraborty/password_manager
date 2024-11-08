import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:password_manager/configs/colors.dart';
import 'package:password_manager/controllers/RecordController.dart';
import 'package:password_manager/models/AddedRecordModel.dart';
import 'package:password_manager/models/ChangeRecordModel.dart';
import 'package:password_manager/models/VerifyRecordModel.dart';

class RecordScreen extends StatefulWidget {
  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with TickerProviderStateMixin {
  late TabController tabCnt;

  RecordController recordController = Get.put(RecordController());

  @override
  void initState() {
    tabCnt = TabController(vsync: this, length: 3, initialIndex: 0);
    super.initState();

    getRecords();
  }


  @override
  void dispose() {
    Get.delete<RecordController>();
    super.dispose();
  }

  getRecords() {
    recordController.getAddedRecords().then((value) => setState(() {}));
    recordController.getVerifyRecords().then((value) => setState(() {}));
    recordController.getChangeRecords().then((value) => setState(() {}));
  }

  List<Widget> tabs() {
    return [
      const Tab(text: "Added Histories"),
      const Tab(text: "Verified Histories"),
      const Tab(text: "Change Histories")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text("Records",
            style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black)),
        centerTitle: false,
        backgroundColor: AppColors.offWhite,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async{
            recordController.verifyRecords = null;
            recordController.addedRecords = null;
            recordController.changeRecords = null;
            getRecords();
            await Future.delayed(const Duration(seconds: 1));
            return ;
          },
          child: SizedBox(
            height: Get.height,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  labelStyle: GoogleFonts.montserrat(color: AppColors.white),
                  tabAlignment: TabAlignment.start,
                  unselectedLabelStyle: GoogleFonts.montserrat(),
                  tabs: tabs(),
                  controller: tabCnt,
                  labelColor: AppColors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.blue,
                ),
                Expanded(
                  child: TabBarView(controller: tabCnt, children: [
                    addedHistoryLayout(),
                    verifyHistoryLayout(),
                    changeHistoryLayout(),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  loadingWidget() {
    return ListView.builder(
        itemBuilder: (context, index) {
          return loadingCard(index);
        },
        itemCount: 15,
        shrinkWrap: true);
  }

  loadingCard(int index) {
    return Container(
      height: 30,
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: (index % 2 == 0)
            ? Colors.transparent
            : AppColors.white.withOpacity(0.05),
      ),
    );
  }

  addedHistoryLayout() {
    return Column(
      children: [
        header(),
        Expanded(
            child: recordController.addedRecords == null
                ? loadingWidget()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return addedDataCard(
                          index, recordController.addedRecords!.data![index]);
                    },
                    itemCount: recordController.addedRecords?.data?.length ?? 0,
                    shrinkWrap: true))
      ],
    );
  }

  changeHistoryLayout() {
    return Column(
      children: [
        header(),
        Expanded(
            child: recordController.changeRecords == null
                ? loadingWidget()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return changeDataCard(index,
                          recordController.changeRecords!.data![index]);
                    },
                    itemCount:
                        recordController.changeRecords?.data?.length ?? 0,
                    shrinkWrap: true))
      ],
    );
  }

  verifyHistoryLayout() {
    return Column(
      children: [
        header(),
        Expanded(
            child: recordController.changeRecords == null
                ? loadingWidget()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return verifyDataCard(index,
                          recordController.verifyRecords!.data![index]);
                    },
                    itemCount:
                        recordController.changeRecords?.data?.length ?? 0,
                    shrinkWrap: true))
      ],
    );
  }

  header() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 5, child: Center(child: headerText("Title"))),
          Expanded(flex: 3, child: Center(child: headerText("Type"))),
          Expanded(flex: 5, child: Center(child: headerText("Date &\n Time"))),
        ],
      ),
    );
  }

  headerText(String txt) {
    return Text(txt,
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
            color: AppColors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 16));
  }

  addedDataCard(int index, AddedRecord record) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: (index % 2 == 0)
            ? Colors.transparent
            : AppColors.white.withOpacity(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: Center(child: dataText(record.title ?? ""))),
          Expanded(
              flex: 3,
              child: Center(child: dataText(record.passwordType ?? ""))),
          Expanded(
              flex: 5,
              child: Center(
                  child: dataText(
                      "${record.createdAt != null ? formatDateString(record.createdAt!) : ""}\n${record.createdAt != null ? formatTimeString(record.createdAt!) : ""}")))
        ],
      ),
    );
  }

  verifyDataCard(int index, VerifyRecord record) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: (index % 2 == 0)
            ? Colors.transparent
            : AppColors.white.withOpacity(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 5,
              child: Center(child: dataText(record.password?.title ?? ""))),
          Expanded(
              flex: 3,
              child:
                  Center(child: dataText(record.password?.passwordType ?? ""))),
          Expanded(
              flex: 5,
              child: Center(
                  child: dataText(
                      "${record.updatedAt != null ? formatDateString(record.updatedAt!) : ""}\n${record.updatedAt != null ? formatTimeString(record.updatedAt!) : ""}")))
        ],
      ),
    );
  }

  changeDataCard(int index, ChangeRecord record) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: (index % 2 == 0)
            ? Colors.transparent
            : AppColors.white.withOpacity(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 5,
              child: Center(child: dataText(record.password?.title ?? ""))),
          Expanded(
              flex: 3,
              child:
                  Center(child: dataText(record.password?.passwordType ?? ""))),
          Expanded(
              flex: 5,
              child: Center(
                  child: dataText(
                      "${record.updatedAt != null ? formatDateString(record.updatedAt!) : ""}\n${record.updatedAt != null ? formatTimeString(record.updatedAt!) : ""}")))
        ],
      ),
    );
  }

  dataText(String txt) {
    return Text(txt,
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(color: AppColors.black, fontSize: 14));
  }

  String formatDateString(String isoDateString) {
    // Parse the ISO 8601 date string to a DateTime object
    DateTime dateTime = DateTime.parse(isoDateString);

    // Create a DateFormat object with the desired format
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');

    // Format the DateTime object to a string
    String formattedDate = dateFormat.format(dateTime);

    return formattedDate;
  }

  String formatTimeString(String isoDateString) {
    // Parse the ISO 8601 date string to a DateTime object
    DateTime dateTime = DateTime.parse(isoDateString);

    // Create a DateFormat object with the desired format
    DateFormat timeFormat = DateFormat('hh:mm a');

    // Format the DateTime object to a string
    String formattedTime = timeFormat.format(dateTime);

    return formattedTime;
  }
}
