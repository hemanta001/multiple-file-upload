<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'txn.label', default: 'Txn')}" />
        <asset:javascript src="fileupload.js"/>
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        <style>
        .card {
            margin-top: 100px;
        }
        .btn-upload {
            padding: 10px 20px;
            margin-left: 10px;
        }
        .upload-input-group {
            margin-bottom: 10px;
        }

        .input-group>.custom-select:not(:last-child), .input-group>.form-control:not(:last-child) {
            height: 45px;
        }
        input, label {
            display:block;
        }
        </style>
    </head>
    <body>
%{--        <a href="#create-txn" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>--}%
%{--        <div class="nav" role="navigation">--}%
%{--            <ul>--}%
%{--                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>--}%
%{--                <li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>--}%
%{--            </ul>--}%
%{--        </div>--}%
%{--        <div id="create-txn" class="content scaffold-create" role="main">--}%
%{--            <h1><g:message code="default.create.label" args="[entityName]" /></h1>--}%
%{--            <g:if test="${flash.message}">--}%
%{--            <div class="message" role="status">${flash.message}</div>--}%
%{--            </g:if>--}%
%{--            <g:hasErrors bean="${this.txn}">--}%
%{--            <ul class="errors" role="alert">--}%
%{--                <g:eachError bean="${this.txn}" var="error">--}%
%{--                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>--}%
%{--                </g:eachError>--}%
%{--            </ul>--}%
%{--            </g:hasErrors>--}%
%{--            <g:form resource="${this.txn}" method="POST" enctype='multipart/form-data'>--}%
%{--                <fieldset class="form">--}%
%{--                    <f:all bean="txn" except="docs"/>--}%


%{--                    <div class='fieldcontain'>--}%
%{--                        <label for='isQRCoordinates'>Has QR Coordinates</label>--}%
%{--                        <input type="hidden" name="docs[0]._isQRCoordinates" />--}%
%{--                        <input type="checkbox" name="docs[0].isQRCoordinates" id="isQRCoordinates"  />--}%
%{--                    </div>--}%
%{--                    <div class='fieldcontain required'>--}%
%{--                        <label for='qrCoordinates'>Qr Coordinates--}%
%{--                            <span class='required-indicator'>*</span>--}%
%{--                        </label><input type="text" name="docs[0].qrCoordinates" value="" required="" id="qrCoordinates" />--}%
%{--                    </div>--}%
%{--                    <div class='fieldcontain required'>--}%
%{--                        <label for='file'>Document to be signed--}%
%{--                            <span class='required-indicator'>*</span>--}%
%{--                        </label><input type="file" name="file" value="" required="" id="file" multiple/>--}%
%{--                    </div>--}%
%{--                    <div class='fieldcontain required'>--}%
%{--                        <label for='docInfo'>Doc Info--}%
%{--                            <span class='required-indicator'>*</span>--}%
%{--                        </label><input type="text" name="docs[0].docInfo" value="" required="" id="docInfo" />--}%
%{--                    </div>--}%
%{--                    <div class='fieldcontain'>--}%
%{--                        <label for='lockPdf'>Lock PDF for other signer?</label>--}%
%{--                        <input type="hidden" name="docs[0]._lockPdf" />--}%
%{--                        <input type="checkbox" name="docs[0].lockPdf" id="lockPdf"  />--}%
%{--                    </div>--}%
%{--                </fieldset>--}%
%{--                <fieldset class="buttons">--}%
%{--                    <g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />--}%
%{--                </fieldset>--}%
%{--            </g:form>--}%
%{--        </div>--}%
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-header">
                    </div>
                    <div class="card-body card-block">
                        <g:form resource="${this.txn}" method="post" enctype="multipart/form-data" class="form-horizontal">


                            <div class="row form-group">
                                <div class="col-12 col-md-12">

                                    <div class="control-group">
                                        <div class='fieldcontain required'>
                                            <label for='txnId'>Txn Id
                                                <span class='required-indicator'>*</span>
                                            </label><input type="text" class="form-control" name="txnId" value="" required="" id="txnId" />
                                        </div>
                                        <div class='fieldcontain required'>
                                            <label for='notifyUser'>Notify User
                                                <span class='required-indicator'>*</span>
                                            </label><input type="checkbox" name="notifyUser" required="" id="notifyUser" />
                                        </div>
                                        <div class='fieldcontain required'>
                                            <label for='signer'>Signer
                                                <span class='required-indicator'>*</span>
                                            </label><g:select class="form-control" id="signer" name="signer"
                                                                                                      from="${User.findAll()}" optionKey="id" optionValue="email"
                                                                                                       title="choose User "/>

                                        </div>
                                        <div class='fieldcontain required'>
                                            <label for='txnType'>Txn Type
                                                <span class='required-indicator'>*</span>
                                            </label>
                                            <input type="text" class="form-control" name="txnType" value="" required="" id="txnType" />
                                        </div>
<br>
                                        <div class="controls">
                                            <div class="entry input-group upload-input-group">
                                                <div>
                                                    <label for="signCoordinates">signCoordinates</label>
                                                    <input type="text" name="docs[0].signCoordinates" id="signCoordinates" placeholder="signCoordinates" class="signCoordinates form-control" required=""/>
                                                </div>
                                                <div>
                                                    <label for="page">page</label>
                                                <input type="number" name="docs[0].page" placeholder="page" id="page" value="" class="page form-control" required=""/>
                                                </div>
                                                <div>
                                                    <label for="isQRCoordinates">isQR</label>
                                                <input type="checkbox" name="docs[0].isQRCoordinates" id="isQRCoordinates" placeholder="isQr"  class="isQRCoordinates form-control" />
                                                </div>
                                                <div>
                                                    <label for="qrCoordinates">qrCoordinates</label>
                                                <input type="text" name="docs[0].qrCoordinates" id="qrCoordinates" value="" placeholder="qrCoordinates" required="" class="qrCoordinates form-control" />
                                                </div>
                                                <div>
                                                    <label for="file">file</label>
                                                <input class="form-control" id="file" name="file" type="file">
                                                </div>
                                                <div>
                                                    <label for="docInfo">DocInfo</label>
                                                <input type="text" name="docs[0].docInfo" placeholder="docInfo" id="docInfo" class="docInfo form-control" value="" required=""  />
                                                </div>
                                                <div>
                                                    <label for="lockPdf">lockPdf</label>

                                                    <input type="checkbox" name="docs[0].lockPdf" id="lockPdf" placeholder="lockPdf" class="lockPdf form-control"/>
                                                </div>
                                                <button class="btn btn-upload btn-success btn-add" type="button">
                                                    <i class="fa fa-plus"></i>
                                                </button>
                                            </div>


                                        </div>
                                        <button class="btn btn-primary">Upload</button>

                                    </div>


                                </div>

                            </div>

                        </g:form>
                    </div>
                </div>
            </div>
        </div>
    </div>
<script>
    var count = 1
    $(function () {
        $(document).on('click', '.btn-add', function (e) {
            e.preventDefault();
            var controlForm = $('.controls:first'),
                currentEntry = $(this).parents('.entry:first'),
                htmlDiv=currentEntry.clone();
            htmlDiv.find('.signCoordinates').attr({ name: "docs["+count+"].signCoordinates"});
            htmlDiv.find('.page').attr({ name: "docs["+count+"].page"});
            htmlDiv.find('.isQRCoordinates').attr({ name: "docs["+count+"].isQRCoordinates"});
            htmlDiv.find('.qrCoordinates').attr({ name: "docs["+count+"].qrCoordinates"});
            htmlDiv.find('.docInfo').attr({ name: "docs["+count+"].docInfo"});
            htmlDiv.find('.lockPdf').attr({ name: "docs["+count+"].lockPdf"});

            newEntry = $(htmlDiv).appendTo(controlForm);

            newEntry.find('input').val('');
            controlForm.find('.entry:not(:last) .btn-add')
                .removeClass('btn-add').addClass('btn-remove')
                .removeClass('btn-success').addClass('btn-danger')
                .html('<span class="fa fa-trash"></span>');
            count++;
        }).on('click', '.btn-remove', function (e) {
            $(this).parents('.entry:first').remove();
            count--;
            e.preventDefault();
            return false;
        });
    });

</script>
    </body>
</html>
