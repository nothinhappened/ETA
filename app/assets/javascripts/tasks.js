/**
 * Created by Logan on 6/18/2014.
 */
function newTaskSubmitForm()
{
    var usersSelectedArray = [];
    $("#selected_users").find("option").each( function(){ usersSelectedArray.push(this.value)});
    $("#selected_users_json").val(JSON.stringify(usersSelectedArray));

    document.tasks_create_form.submit();
}