/* Javascript move code from DeveloperGeekResources.com */
/**
 * Code moves entries between multi-select boxes (also called listboxes) when called*
 * To use: add code to a javascript action (such as a button) with tbFrom and tbTo specified. When called, method will move entries selected in tbFrom select to the tbTo select
 * @param tbFrom A reference to the source listbox, with selected entries
 * @param tbTo A reference to the destination listbox
 */
function lb_move(tbFrom, tbTo)
{
    var arrFrom = []; var arrTo = [];
    var arrLU = [];
    var no;
    var i;
    for (i = 0; i < tbTo.options.length; i++)
    {
        arrLU[tbTo.options[i].text] = tbTo.options[i].value;
        arrTo[i] = tbTo.options[i].text;
    }
    var fLength = 0;
    var tLength = arrTo.length;
    for(i = 0; i < tbFrom.options.length; i++)
    {
        arrLU[tbFrom.options[i].text] = tbFrom.options[i].value;
        if (tbFrom.options[i].selected && tbFrom.options[i].value != "")
        {
            arrTo[tLength] = tbFrom.options[i].text;
            tLength++;
        }
        else
        {
            arrFrom[fLength] = tbFrom.options[i].text;
            fLength++;
        }
    }
    tbFrom.length = 0;
    tbTo.length = 0;
    for(i = 0; i < arrFrom.length; i++)
    {
        no = new Option();
        no.value = arrLU[arrFrom[i]];
        no.text = arrFrom[i];
        tbFrom[i] = no;
    }

    for(i = 0; i < arrTo.length; i++)
    {
        no = new Option();
        no.value = arrLU[arrTo[i]];
        no.text = arrTo[i];
        tbTo[i] = no;
    }
}
