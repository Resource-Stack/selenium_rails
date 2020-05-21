$(document).ready(function () {
    var table = null;

    function getApiUrl(partialUrl) {
        return `${window.location.origin}/${partialUrl}`;
    }

    function initializeDataTable(tableID, suiteID) {
        var processing = false;
        var serverSide = true;
        var paging = true;
        var ordering = false;
        var info = true;
        var searchable = true;
        var searchDelay = 1000;
        var lengthMenu = [10, 20, 50];
        var pagingType = "full_numbers";
        table = $(tableID).DataTable({
            "processing": processing,
            "serverSide": serverSide,
            "searching": searchable,
            "paging": paging,
            "lengthMenu": lengthMenu,
            "ordering": ordering,
            "pagingType": pagingType,
            "info": info,
            "searchDelay": searchDelay,
            "ajax": {
                "url": getApiUrl(`./suite_schedule/get_suite_schedules?suite_id=${suiteID}`),
                "type": "POST"
            },
            "language": {
                "info": "Showing from _START_ till _END_ from the total of _TOTAL_ records."
            },
            "columns": [
                { "data": "id" },
                { "data": "name" },
                { "data": "start_date" },
                { "data": "end_date" },
                { "data": "time" },
                {
                    "defaultContent": `<div>
                                <a href='#' class='edit-item'>Edit</a>
                                <a href='#' class='delete-item'>Delete</a>
                            </div>`}
            ]
        });

        $(`${tableID} tbody`).on('click', '.edit-item', function (e) {
            e.preventDefault();
            var data = table.row($(this).parents('tr')).data();
            $(this).parents('tr').addClass("selected");
            showScheduleForm(data);
        });

        $(`${tableID} tbody`).on('click', '.delete-item', function (e) {
            e.preventDefault();
            var data = table.row($(this).parents('tr')).data();
            $(this).parents('tr').addClass("selected");

            var removeSelectionAction = () => {
                var item = $(tableID).find(".selected");
                if (item) {
                    item.removeClass("selected");
                }
            };
            $().showConfirmationDialog("Delete Schedule", "Are you sure you want to delete this schedule?",
                () => {
                    deleteItem(data.id);
                },
                () => {
                    removeSelectionAction();
                },
                () => {
                    removeSelectionAction();
                });
        });

        function deleteItem(id) {
            $().makeHttpRequest(getApiUrl("./suite_schedule/delete_suite_schedule?id=" + id), "GET", null, (res) => {
                var item = $(tableID).find(".selected");
                $(tableID).dataTable().api().row(item).remove().draw();

                if (item) {
                    item.removeClass("selected");
                }
            });
        }

        function showScheduleForm(data) {
            var model = getDefaultSchedule(suiteID);
            var minDate = model.start_date;
            if (data != null) {
                Object.assign(model, data);
            }

            var forUpdate = model.id > 0;
            var formHtml = `<form id="scheduleForm" style="min-height:250px;">
            <div class="form-group" style="display: none;">
                <label for="id" class="col-md-4 col-form-label text-md-right left-align">Schedule
                ID</label>
                <div >
                    <input type="text" id="id" class="form-control" name="id"
                        value="${model.id}" />
                </div>
            </div>
            <div class="form-group">
                <label for="name" class="col-md-4 col-form-label text-md-right left-align left-label">Schedule
                    Name</label>
                <div >
                    <input type="text" id="name" class="form-control" name="name" required="true"
                          value="${model.name}" />
                </div>
            </div>
          
            <div class="form-group">
                <label for="start_date" class="col-md-4 col-form-label text-md-right left-align left-label" >Start
                    Date</label>
                <div >
                    <input type="date" id="start_date" class="form-control" name="start_date" min="${minDate}" value="${
                model.start_date
                }" required="true" />
                </div>
            </div>

            <div class="form-group">
            <label for="end_date" class="col-md-4 col-form-label text-md-right left-align left-label">End
                Date</label>
            <div >
                <input type="date" id="end_date" class="form-control" name="end_date" min="${minDate}" value="${
                model.end_date
                }" required="true"  />
            </div>
        </div>
          
            <div class="form-group">
                <label for="time" class="col-md-4 col-form-label text-md-right left-align left-label">Time</label>
                <div >
                <input type="time" id="time" class="form-control" name="time" value="${
                model.time
                }"  required="true"/>
                </div>
            </div>
          
            <div class="col-md-6 offset-md-4" style="display: flex; justify-content: center; width: 100%; margin-top:5px;">
                <button type="submit" class="btn btn-primary md-5">
                    Save
                </button>
            </div>
          </form>`;

            $().showHtmlDialog(
                forUpdate ? "Update Schedule" : "Create new Schedule",
                formHtml, () => {
                    var item = $(tableID).find(".selected");
                    if (item) {
                        item.removeClass("selected");
                    }
                }
            );

            $("#scheduleForm").submit(function (e) {
                e.preventDefault();
                var form = $(this);

                var dataToSave = $().getFormData(form, getDefaultSchedule(suiteID));

                createNewSchedule(suiteID, dataToSave);
            });
        }

        $("#btnAddNew").on('click', function () {
            showScheduleForm(null);
        });
    }

    function getDefaultSchedule(suiteID) {
        var curTime = "10:00";
        var tomorrowDate = new Date();
        tomorrowDate.setDate(tomorrowDate.getDate() + 1)
        return {
            id: -1,
            name: `Run suite at ${curTime}`,
            start_date: new Date().toISOString().split("T")[0],
            end_date: tomorrowDate.toISOString().split("T")[0],
            time: curTime,
            test_suite_id: suiteID
        };
    }

    function createNewSchedule(suiteID, data = null) {
        var dataToSave = getDefaultSchedule(suiteID);
        var forUpdate = false;
        var scheduleImmediately = true;
        if (data != null) {
            Object.assign(dataToSave, data);
            scheduleImmediately = false;
        }
        forUpdate = dataToSave.id > 0;
        var tableID = "#scheduleTable";

        $().makeHttpRequest(getApiUrl(`./suite_schedule/${(forUpdate ? "update_suite_schedule" : "create_suite_schedule")}`), "POST", { suite_schedule: dataToSave, schedule_immediately: scheduleImmediately }, (data) => {
            if (forUpdate > 0) {
                var item = $(tableID).find(".selected");
                $(tableID).dataTable().fnUpdate(data, item.index(), undefined, false);

                if (item) {
                    item.removeClass("selected");
                }
            }
            else {
                $(tableID).dataTable().api().row.add(data).draw();
            }
            $().hideHtmlDialog();
        }, (error) => {
            $().showMessage("Error", error);
            var item = $(tableID).find(".selected");
            if (item) {
                item.removeClass("selected");
            }
        });
    }

    $("#btnScheduleNow").on('click', function (e) {
        e.preventDefault();
        var suiteID = $(this).data("id");
        createNewSchedule(suiteID);
    });

    $("#btnScheduleLater").on('click', function (e) {
        e.preventDefault();
        var suiteID = $(this).data("id");
        var suiteName = $(this).data("name");

        var html = `<div>
            <div style="display:flex; justify-content: flex-end; padding: 5px;">
                <button id="btnAddNew" class="btn btn-primary btn-sm">Add New</button>
            </div>
            <table id="scheduleTable" class="table table-bordered table-responsive table-hover stripe">
                <thead>
                     <tr>
                        <th>Id</th>
                        <th>Name</th>
                        <th>Start Date </th>
                        <th>End Date</th>
                        <th>Time</th>
                     </tr>
                </thead>
            </table>
        </div>`;
        $().showHtmlDialog(
            suiteName,
            html
        );

        initializeDataTable("#scheduleTable", suiteID);
    });
});