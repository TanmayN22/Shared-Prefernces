Shared Preferences 

Step 1 : Save the data 

String? _savedData;

  Future saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();  -- get instance 
    await prefs.setString(key, value);                    -- then set the values 
    setState(() {                                         -- then setState to save in it
      _savedData = value;
    });
  }

Had a question of why is final used and why in the function why is it not declared outside like 

  prefs? SharedPreferences.getInstance() 
  or 
  prefs = SharedPreferences.getInstance()

Answer : 

prefs is only accessible within that function, so it can’t accidentally be accessed or modified from other parts of the code.

If we declared prefs outside the function, like this:

SharedPreferences prefs = SharedPreferences.getInstance();  // This line will actually not work as expected

We’d run into two main issues:

Shared Preferences is Asynchronous: Since SharedPreferences.getInstance() is an asynchronous operation (returns a Future), you cannot directly assign it to prefs like this outside the function. You need to wait for it to complete, which requires await, and await can only be used within an async function. Therefore, this line would not work outside an async function.

Global State and Unintended Reuse: If we declare prefs as a global variable outside the function, it could lead to unintended behaviors. Multiple parts of your app might access and modify it without realizing the consequences, potentially leading to bugs, data inconsistency, or unexpected behavior.

If you need access to the same SharedPreferences instance across different parts of the app, you can:

Initialize it Once in the App: For example, in the main function or a service class, and then pass it to other parts of the app.

Use a Singleton Pattern: This pattern would initialize SharedPreferences once and then reuse that instance. Here’s an example:

class SharedPrefsHelper {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> getInstance() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }
}

step 2 : 

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Text(_savedData ?? 'No Data Saved'),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                saveData("name", 'Tanmay');
                },
            child: const Icon(Icons.add),
            ),
        );
    }

create a key and assign the value to it here: the key is "name" and the value is "Tanmay" 

step 3 : retrive the data


Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final saveData = prefs.getString("name");
    setState(() {
      _savedData = saveData;
    });
  }

  assign the key by using it in .get... and using this _loadSavedData in initState , we didnt directly assign this in initState as it can't be async

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

and there you have it , you have saved the value in your app.




