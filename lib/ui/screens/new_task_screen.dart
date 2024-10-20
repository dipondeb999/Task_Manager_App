import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/network_response.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/models/task_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_app/ui/utils/app_colors.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_app/ui/widgets/task_card.dart';
import 'package:task_manager_app/ui/widgets/task_summary_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskListInProgress = false;

  List<TaskModel> _newTaskList = [];

  @override
  void initState() {
    _getNewTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _getNewTaskList();
        },
        child: Column(
          children: [
            _buildSummarySection(),
            Expanded(
              child: Visibility(
                visible: !_getNewTaskListInProgress,
                replacement: const CenteredCircularProgressIndicator(),
                child: ListView.separated(
                  itemCount: _newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskModel: _newTaskList[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapFloatingActionButton,
        backgroundColor: AppColors.themeColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TaskSummaryCard(
              title: 'New',
              count: 09,
            ),
            TaskSummaryCard(
              title: 'Completed',
              count: 09,
            ),
            TaskSummaryCard(
              title: 'Cancelled',
              count: 09,
            ),
            TaskSummaryCard(
              title: 'Progress',
              count: 09,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapFloatingActionButton() async {
    bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );
    if (shouldRefresh == true) {
      _getNewTaskList();
    }
  }

  Future<void> _getNewTaskList() async {
    _newTaskList.clear();
    _getNewTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.newTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _newTaskList = taskListModel.taskList ?? [];
    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getNewTaskListInProgress = false;
    setState(() {});
  }
}
