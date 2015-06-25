/**
 * Created by Logan on 6/18/2014.
 */
function userTasksSubmitForm()
{
    var tasksSelectedArray = [];
    $("#selected_tasks").find("option").each( function(){ tasksSelectedArray.push(this.value)});
    $("#selected_tasks_json").val(JSON.stringify(tasksSelectedArray));

    document.user_tasks_form.submit();
}

/*Base is the URL to be redirected to, ie "<%= user_tasks_url %>" */
function userTasksSelectChange(base)
{
    var selectedUser = document.getElementById("user").value;
    window.location=base.concat("/").concat(selectedUser);
}