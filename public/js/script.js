// Combobox selection script to populate table
var $addTable = function(){
    return $('<table><tbody><tr>This is a row</tr></tbody></table>')
}
$('#table').html($addTable);
function getComboA(sel) {
    var value = sel.options[sel.selectedIndex].value;
    console.log(value);
    var object = #{@curve.to_json};
    console.log(object);
}
