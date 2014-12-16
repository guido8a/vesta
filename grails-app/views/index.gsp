<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <link rel="icon" href="../../favicon.ico">

        <title>Theme Template for Bootstrap</title>

        <!-- Bootstrap core CSS -->
        <link href="${resource(dir: 'bootstrap-3.3.1/dist/css', file: 'bootstrap.min.css')}" rel="stylesheet">
        <!-- Bootstrap theme -->
        <link href="${resource(dir: 'bootstrap-3.3.1/dist/css', file: 'bootstrap-theme.min.css')}" rel="stylesheet">

        <!-- Jquery UI -->
        <link href="${resource(dir: 'js/jquery-ui-1.11.2', file: 'jquery-ui.min.js')}" rel="stylesheet">
        <link href="${resource(dir: 'js/jquery-ui-1.11.2', file: 'jquery-ui.structure.min.css')}" rel="stylesheet">
        <link href="${resource(dir: 'js/jquery-ui-1.11.2', file: 'jquery-ui.theme.min.css')}" rel="stylesheet">

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

        <style type="text/css">
        body {
            padding-top    : 100px;
            padding-bottom : 30px;
        }

        .container {
            /*background : #191919;*/
            border-left  : solid 1px #555;
            border-right : solid 1px #555;
        }
        </style>

    </head>

    <body role="document">

        <!-- Fixed navbar -->
        <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="#">Bootstrap theme</a>
                </div>

                <div id="navbar" class="navbar-collapse collapse">
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="#">Home</a></li>
                        <li><a href="login.gsp">Login</a></li>
                        <li><a href="#contact">Contact</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Dropdown <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="#">Action</a></li>
                                <li><a href="#">Another action</a></li>
                                <li><a href="#">Something else here</a></li>
                                <li class="divider"></li>
                                <li class="dropdown-header">Nav header</li>
                                <li><a href="#">Separated link</a></li>
                                <li><a href="#">One more separated link</a></li>
                            </ul>
                        </li>
                    </ul>
                </div><!--/.nav-collapse -->
            </div>
        </nav>

        <div class="container theme-showcase" role="main">

            <h1>h1. Bootstrap heading</h1>
            <h2>h2. Bootstrap heading</h2>
            <h3>h3. Bootstrap heading</h3>
            <h4>h4. Bootstrap heading</h4>
            <h5>h5. Bootstrap heading</h5>
            <h6>h6. Bootstrap heading</h6>

            <div class="page-header">
                <h1>tdn-tab</h1>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="tdn-tab tdn-tab-left">
                        <div class="tdn-tab-heading">
                            <a href="#">Entrada</a>
                        </div>

                        <div class="tdn-tab-body">
                            Content area nada
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="tdn-tab tdn-tab-left tdn-tab-primary">
                        <div class="tdn-tab-heading">
                            <a href="#" class="selected">Entrada</a>
                        </div>

                        <div class="tdn-tab-body">
                            Content area primary
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="tdn-tab">
                        <div class="tdn-tab-heading">
                            <a href="#">Home</a>
                            <a href="#" class="selected">Projects</a>
                            <a href="#">About</a>
                        </div>

                        <div class="tdn-tab-body">
                            Content area nada
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="tdn-tab tdn-tab-left tdn-tab-primary">
                        <div class="tdn-tab-heading">
                            <a href="#">Home</a>
                            <a href="#" class="selected">Projects</a>
                            <a href="#">About</a>
                        </div>

                        <div class="tdn-tab-body">
                            Content area primary
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="tdn-tab tdn-tab-right tdn-tab-success">
                        <div class="tdn-tab-heading">
                            <a href="#">Home</a>
                            <a href="#" class="selected">Projects</a>
                            <a href="#">About</a>
                        </div>

                        <div class="tdn-tab-body">
                            Content area success
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="tdn-tab tdn-tab-info">
                        <div class="tdn-tab-heading">
                            <a href="#">Home</a>
                            <a href="#" class="selected">Projects</a>
                            <a href="#">About</a>
                        </div>

                        <div class="tdn-tab-body">
                            Content area info
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="tdn-tab tdn-tab-right tdn-tab-warning">
                        <div class="tdn-tab-heading">
                            <a href="#">Home</a>
                            <a href="#" class="selected">Projects</a>
                            <a href="#">About</a>
                        </div>

                        <div class="tdn-tab-body">
                            Content area warning
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="tdn-tab tdn-tab-right tdn-tab-danger">
                        <div class="tdn-tab-heading">
                            <a href="#">Home</a>
                            <a href="#" class="selected">Projects</a>
                            <a href="#">About</a>
                        </div>

                        <div class="tdn-tab-body">
                            Content area danger
                        </div>
                    </div>
                </div>
            </div>

            <div class="page-header">
                <h1>tdn-notes</h1>
            </div>

            <div class="tdn-note alert alert-success alert-dismissible" role="alert">
                <button type="button" class="close" data-dismiss="alert">
                    <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
                </button>
                %{--<h4>Title</h4>--}%
                <strong>Well done!</strong> You successfully read this important alert message.
                <p>
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tincidunt lacinia lacus, at placerat ipsum euismod vitae. Pellentesque ac mollis felis, eget congue nulla. Integer efficitur ex sed lorem euismod, sit amet accumsan ante molestie. Quisque rutrum, nisi nec tempor blandit, arcu ante semper turpis, sit amet viverra metus sem nec lectus. Mauris aliquam dui eros. Nunc vitae blandit lacus. Proin ullamcorper dictum nunc. Sed sed risus id justo ornare feugiat. Donec efficitur mi quis leo bibendum, ut molestie risus condimentum. Ut ex risus, luctus eu ipsum nec, condimentum accumsan dolor.
                </p>

                <p>
                    <a href="#" class="alert-link">LINK</a>
                </p>
            </div>

            <div class="tdn-note alert alert-info" role="alert">
                <strong>Heads up!</strong> This alert needs your attention, but it's not super important.
                <p>
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tincidunt lacinia lacus, at placerat ipsum euismod vitae. Pellentesque ac mollis felis, eget congue nulla. Integer efficitur ex sed lorem euismod, sit amet accumsan ante molestie. Quisque rutrum, nisi nec tempor blandit, arcu ante semper turpis, sit amet viverra metus sem nec lectus. Mauris aliquam dui eros. Nunc vitae blandit lacus. Proin ullamcorper dictum nunc. Sed sed risus id justo ornare feugiat. Donec efficitur mi quis leo bibendum, ut molestie risus condimentum. Ut ex risus, luctus eu ipsum nec, condimentum accumsan dolor.
                </p>
            </div>

            <div class="tdn-note alert alert-warning" role="alert">
                <strong>Warning!</strong> Best check yo self, you're not looking too good.
            </div>

            <div class="tdn-note alert alert-danger alert-dismissible" role="alert">
                <button type="button" class="close" data-dismiss="alert">
                    <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
                </button>
                <strong>Oh snap!</strong> Change a few things up and try submitting again.
            </div>

            <div class="page-header">
                <h1>tdn-notes Right</h1>
            </div>

            <div class="tdn-note-right alert alert-success alert-dismissible" role="alert">
                <button type="button" class="close" data-dismiss="alert">
                    <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
                </button>
                %{--<h4>Title</h4>--}%
                <strong>Well done!</strong> You successfully read this important alert message.
                <p>
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tincidunt lacinia lacus, at placerat ipsum euismod vitae. Pellentesque ac mollis felis, eget congue nulla. Integer efficitur ex sed lorem euismod, sit amet accumsan ante molestie. Quisque rutrum, nisi nec tempor blandit, arcu ante semper turpis, sit amet viverra metus sem nec lectus. Mauris aliquam dui eros. Nunc vitae blandit lacus. Proin ullamcorper dictum nunc. Sed sed risus id justo ornare feugiat. Donec efficitur mi quis leo bibendum, ut molestie risus condimentum. Ut ex risus, luctus eu ipsum nec, condimentum accumsan dolor.
                </p>

                <p>
                    <a href="#" class="alert-link">LINK</a>
                </p>
            </div>

            <div class="tdn-note-right alert alert-info" role="alert">
                <strong>Heads up!</strong> This alert needs your attention, but it's not super important.
                <p>
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tincidunt lacinia lacus, at placerat ipsum euismod vitae. Pellentesque ac mollis felis, eget congue nulla. Integer efficitur ex sed lorem euismod, sit amet accumsan ante molestie. Quisque rutrum, nisi nec tempor blandit, arcu ante semper turpis, sit amet viverra metus sem nec lectus. Mauris aliquam dui eros. Nunc vitae blandit lacus. Proin ullamcorper dictum nunc. Sed sed risus id justo ornare feugiat. Donec efficitur mi quis leo bibendum, ut molestie risus condimentum. Ut ex risus, luctus eu ipsum nec, condimentum accumsan dolor.
                </p>
            </div>

            <div class="tdn-note-right alert alert-warning" role="alert">
                <strong>Warning!</strong> Best check yo self, you're not looking too good.
            </div>

            <div class="tdn-note-right alert alert-danger alert-dismissible" role="alert">
                <button type="button" class="close" data-dismiss="alert">
                    <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
                </button>
                <strong>Oh snap!</strong> Change a few things up and try submitting again.
            </div>

            <div class="page-header">
                <h1>Alerts</h1>
            </div>

            <div class="alert alert-primary" role="alert">
                <strong>Well done!</strong> You successfully read this important alert message.

                <p>
                    <a href="#" class="alert-link">LINK</a>
                </p>
            </div>

            <div class="alert alert-success" role="alert">
                <strong>Well done!</strong> You successfully read this important alert message.

                <p>
                    <a href="#" class="alert-link">LINK</a>
                </p>
            </div>

            <div class="alert alert-info" role="alert">
                <strong>Heads up!</strong> This alert needs your attention, but it's not super important.

                <p>
                    <a href="#" class="alert-link">LINK</a>
                </p>
            </div>

            <div class="alert alert-warning" role="alert">
                <strong>Warning!</strong> Best check yo self, you're not looking too good.

                <p>
                    <a href="#" class="alert-link">LINK</a>
                </p>
            </div>

            <div class="alert alert-danger alert-dismissible" role="alert">
                <button type="button" class="close" data-dismiss="alert">
                    <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
                </button>
                <strong>Oh snap!</strong> Change a few things up and try submitting again.

                <p>
                    <a href="#" class="alert-link">LINK</a>
                </p>
            </div>

            <!-- Main jumbotron for a primary marketing message or call to action -->
            <div class="jumbotron">
                <h1>Hello, world!</h1>

                <p>This is a template for a simple marketing or informational website. It includes a large callout called a jumbotron and three supporting pieces of content. Use it as a starting point to create something more unique.</p>

                <p><a href="#" class="btn btn-primary btn-lg" role="button">Learn more &raquo;</a></p>
            </div>


            <div class="page-header">
                <h1>Buttons</h1>
            </div>

            <p>
                <button type="button" class="btn btn-lg btn-default">Default</button>
                <button type="button" class="btn btn-lg btn-primary">Primary</button>
                <button type="button" class="btn btn-lg btn-success">Success</button>
                <button type="button" class="btn btn-lg btn-info">Info</button>
                <button type="button" class="btn btn-lg btn-warning">Warning</button>
                <button type="button" class="btn btn-lg btn-danger">Danger</button>
                <button type="button" class="btn btn-lg btn-link">Link</button>
            </p>

            <p>
                <button type="button" class="btn btn-default">Default</button>
                <button type="button" class="btn btn-primary">Primary</button>
                <button type="button" class="btn btn-success">Success</button>
                <button type="button" class="btn btn-info">Info</button>
                <button type="button" class="btn btn-warning">Warning</button>
                <button type="button" class="btn btn-danger">Danger</button>
                <button type="button" class="btn btn-link">Link</button>
            </p>

            <p>
                <button type="button" class="btn btn-sm btn-default">Default</button>
                <button type="button" class="btn btn-sm btn-primary">Primary</button>
                <button type="button" class="btn btn-sm btn-success">Success</button>
                <button type="button" class="btn btn-sm btn-info">Info</button>
                <button type="button" class="btn btn-sm btn-warning">Warning</button>
                <button type="button" class="btn btn-sm btn-danger">Danger</button>
                <button type="button" class="btn btn-sm btn-link">Link</button>
            </p>

            <p>
                <button type="button" class="btn btn-xs btn-default">Default</button>
                <button type="button" class="btn btn-xs btn-primary">Primary</button>
                <button type="button" class="btn btn-xs btn-success">Success</button>
                <button type="button" class="btn btn-xs btn-info">Info</button>
                <button type="button" class="btn btn-xs btn-warning">Warning</button>
                <button type="button" class="btn btn-xs btn-danger">Danger</button>
                <button type="button" class="btn btn-xs btn-link">Link</button>
            </p>


            <div class="page-header">
                <h1>Tables</h1>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>First Name</th>
                                <th>Last Name</th>
                                <th>Username</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Mark</td>
                                <td>Otto</td>
                                <td>@mdo</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Jacob</td>
                                <td>Thornton</td>
                                <td>@fat</td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>Larry</td>
                                <td>the Bird</td>
                                <td>@twitter</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="col-md-6">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>First Name</th>
                                <th>Last Name</th>
                                <th>Username</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Mark</td>
                                <td>Otto</td>
                                <td>@mdo</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Jacob</td>
                                <td>Thornton</td>
                                <td>@fat</td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td>Larry</td>
                                <td>the Bird</td>
                                <td>@twitter</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>First Name</th>
                                <th>Last Name</th>
                                <th>Username</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td rowspan="2">1</td>
                                <td>Mark</td>
                                <td>Otto</td>
                                <td>@mdo</td>
                            </tr>
                            <tr>
                                <td>Mark</td>
                                <td>Otto</td>
                                <td>@TwBootstrap</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Jacob</td>
                                <td>Thornton</td>
                                <td>@fat</td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td colspan="2">Larry the Bird</td>
                                <td>@twitter</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="col-md-6">
                    <table class="table table-condensed">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>First Name</th>
                                <th>Last Name</th>
                                <th>Username</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Mark</td>
                                <td>Otto</td>
                                <td>@mdo</td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td>Jacob</td>
                                <td>Thornton</td>
                                <td>@fat</td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td colspan="2">Larry the Bird</td>
                                <td>@twitter</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>


            <div class="page-header">
                <h1>Thumbnails</h1>
            </div>
            <img data-src="holder.js/200x200" class="img-thumbnail" alt="A generic square placeholder image with a white border around it, making it resemble a photograph taken with an old instant camera">


            <div class="page-header">
                <h1>Labels</h1>
            </div>

            <h1>
                <span class="label label-default">Default</span>
                <span class="label label-primary">Primary</span>
                <span class="label label-success">Success</span>
                <span class="label label-info">Info</span>
                <span class="label label-warning">Warning</span>
                <span class="label label-danger">Danger</span>
            </h1>

            <h2>
                <span class="label label-default">Default</span>
                <span class="label label-primary">Primary</span>
                <span class="label label-success">Success</span>
                <span class="label label-info">Info</span>
                <span class="label label-warning">Warning</span>
                <span class="label label-danger">Danger</span>
            </h2>

            <h3>
                <span class="label label-default">Default</span>
                <span class="label label-primary">Primary</span>
                <span class="label label-success">Success</span>
                <span class="label label-info">Info</span>
                <span class="label label-warning">Warning</span>
                <span class="label label-danger">Danger</span>
            </h3>
            <h4>
                <span class="label label-default">Default</span>
                <span class="label label-primary">Primary</span>
                <span class="label label-success">Success</span>
                <span class="label label-info">Info</span>
                <span class="label label-warning">Warning</span>
                <span class="label label-danger">Danger</span>
            </h4>
            <h5>
                <span class="label label-default">Default</span>
                <span class="label label-primary">Primary</span>
                <span class="label label-success">Success</span>
                <span class="label label-info">Info</span>
                <span class="label label-warning">Warning</span>
                <span class="label label-danger">Danger</span>
            </h5>
            <h6>
                <span class="label label-default">Default</span>
                <span class="label label-primary">Primary</span>
                <span class="label label-success">Success</span>
                <span class="label label-info">Info</span>
                <span class="label label-warning">Warning</span>
                <span class="label label-danger">Danger</span>
            </h6>

            <p>
                <span class="label label-default">Default</span>
                <span class="label label-primary">Primary</span>
                <span class="label label-success">Success</span>
                <span class="label label-info">Info</span>
                <span class="label label-warning">Warning</span>
                <span class="label label-danger">Danger</span>
            </p>


            <div class="page-header">
                <h1>Badges</h1>
            </div>

            <p>
                <a href="#">Inbox <span class="badge">42</span></a>
            </p>
            <ul class="nav nav-pills" role="tablist">
                <li role="presentation" class="active"><a href="#">Home <span class="badge">42</span></a></li>
                <li role="presentation"><a href="#">Profile</a></li>
                <li role="presentation"><a href="#">Messages <span class="badge">3</span></a></li>
            </ul>


            <div class="page-header">
                <h1>Dropdown menus</h1>
            </div>

            <div class="dropdown theme-dropdown clearfix">
                <a id="dropdownMenu1" href="#" class="sr-only dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Dropdown <span class="caret"></span>
                </a>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                    <li class="active" role="presentation"><a role="menuitem" tabindex="-1" href="#">Action</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Another action</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Something else here</a></li>
                    <li role="presentation" class="divider"></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#">Separated link</a></li>
                </ul>
            </div>

            <div class="page-header">
                <h1>Navs</h1>
            </div>
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active"><a href="#">Home</a></li>
                <li role="presentation"><a href="#">Profile</a></li>
                <li role="presentation"><a href="#">Messages</a></li>
            </ul>
            <ul class="nav nav-pills" role="tablist">
                <li role="presentation" class="active"><a href="#">Home</a></li>
                <li role="presentation"><a href="#">Profile</a></li>
                <li role="presentation"><a href="#">Messages</a></li>
            </ul>

            <div class="page-header">
                <h1>Navbars</h1>
            </div>

            <nav class="navbar navbar-default">
                <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="#">Project name</a>
                    </div>

                    <div class="navbar-collapse collapse">
                        <ul class="nav navbar-nav">
                            <li class="active"><a href="#">Home</a></li>
                            <li><a href="#about">About</a></li>
                            <li><a href="#contact">Contact</a></li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Dropdown <span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu" role="menu">
                                    <li><a href="#">Action</a></li>
                                    <li><a href="#">Another action</a></li>
                                    <li><a href="#">Something else here</a></li>
                                    <li class="divider"></li>
                                    <li class="dropdown-header">Nav header</li>
                                    <li><a href="#">Separated link</a></li>
                                    <li><a href="#">One more separated link</a></li>
                                </ul>
                            </li>
                        </ul>
                    </div><!--/.nav-collapse -->
                </div>
            </nav>

            <nav class="navbar navbar-inverse">
                <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="#">Project name</a>
                    </div>

                    <div class="navbar-collapse collapse">
                        <ul class="nav navbar-nav">
                            <li class="active"><a href="#">Home</a></li>
                            <li><a href="#about">About</a></li>
                            <li><a href="#contact">Contact</a></li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Dropdown <span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu" role="menu">
                                    <li><a href="#">Action</a></li>
                                    <li><a href="#">Another action</a></li>
                                    <li><a href="#">Something else here</a></li>
                                    <li class="divider"></li>
                                    <li class="dropdown-header">Nav header</li>
                                    <li><a href="#">Separated link</a></li>
                                    <li><a href="#">One more separated link</a></li>
                                </ul>
                            </li>
                        </ul>
                    </div><!--/.nav-collapse -->
                </div>
            </nav>


            <div class="page-header">
                <h1>Progress bars</h1>
            </div>

            <div class="progress">
                <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;"><span class="sr-only">60% Complete</span>
                </div>
            </div>

            <div class="progress">
                <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 40%"><span class="sr-only">40% Complete (success)</span>
                </div>
            </div>

            <div class="progress">
                <div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: 20%"><span class="sr-only">20% Complete</span>
                </div>
            </div>

            <div class="progress">
                <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%"><span class="sr-only">60% Complete (warning)</span>
                </div>
            </div>

            <div class="progress">
                <div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100" style="width: 80%"><span class="sr-only">80% Complete (danger)</span>
                </div>
            </div>

            <div class="progress">
                <div class="progress-bar progress-bar-striped" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%"><span class="sr-only">60% Complete</span>
                </div>
            </div>

            <div class="progress">
                <div class="progress-bar progress-bar-success" style="width: 35%"><span class="sr-only">35% Complete (success)</span>
                </div>

                <div class="progress-bar progress-bar-warning" style="width: 20%"><span class="sr-only">20% Complete (warning)</span>
                </div>

                <div class="progress-bar progress-bar-danger" style="width: 10%"><span class='sr-only'>10% Complete (danger)</span>
                </div>
            </div>


            <div class="page-header">
                <h1>List groups</h1>
            </div>

            <div class="row">
                <div class="col-sm-4">
                    <ul class="list-group">
                        <li class="list-group-item">Cras justo odio</li>
                        <li class="list-group-item">Dapibus ac facilisis in</li>
                        <li class="list-group-item">Morbi leo risus</li>
                        <li class="list-group-item">Porta ac consectetur ac</li>
                        <li class="list-group-item">Vestibulum at eros</li>
                    </ul>
                </div><!-- /.col-sm-4 -->
                <div class="col-sm-4">
                    <div class="list-group">
                        <a href="#" class="list-group-item active">
                            Cras justo odio
                        </a>
                        <a href="#" class="list-group-item">Dapibus ac facilisis in</a>
                        <a href="#" class="list-group-item">Morbi leo risus</a>
                        <a href="#" class="list-group-item">Porta ac consectetur ac</a>
                        <a href="#" class="list-group-item">Vestibulum at eros</a>
                    </div>
                </div><!-- /.col-sm-4 -->
                <div class="col-sm-4">
                    <div class="list-group">
                        <a href="#" class="list-group-item active">
                            <h4 class="list-group-item-heading">List group item heading</h4>

                            <p class="list-group-item-text">Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.</p>
                        </a>
                        <a href="#" class="list-group-item">
                            <h4 class="list-group-item-heading">List group item heading</h4>

                            <p class="list-group-item-text">Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.</p>
                        </a>
                        <a href="#" class="list-group-item">
                            <h4 class="list-group-item-heading">List group item heading</h4>

                            <p class="list-group-item-text">Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.</p>
                        </a>
                    </div>
                </div><!-- /.col-sm-4 -->
            </div>


            <div class="page-header">
                <h1>Panels</h1>
            </div>

            <div class="row">
                <div class="col-sm-4">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">Panel title</h3>
                        </div>

                        <div class="panel-body">
                            Panel content
                        </div>
                    </div>

                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h3 class="panel-title">Panel title</h3>
                        </div>

                        <div class="panel-body">
                            Panel content
                        </div>
                    </div>
                </div><!-- /.col-sm-4 -->
                <div class="col-sm-4">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <h3 class="panel-title">Panel title</h3>
                        </div>

                        <div class="panel-body">
                            Panel content
                        </div>
                    </div>

                    <div class="panel panel-info">
                        <div class="panel-heading">
                            <h3 class="panel-title">Panel title</h3>
                        </div>

                        <div class="panel-body">
                            Panel content
                        </div>
                    </div>
                </div><!-- /.col-sm-4 -->
                <div class="col-sm-4">
                    <div class="panel panel-warning">
                        <div class="panel-heading">
                            <h3 class="panel-title">Panel title</h3>
                        </div>

                        <div class="panel-body">
                            Panel content
                        </div>
                    </div>

                    <div class="panel panel-danger">
                        <div class="panel-heading">
                            <h3 class="panel-title">Panel title</h3>
                        </div>

                        <div class="panel-body">
                            Panel content
                        </div>
                    </div>
                </div><!-- /.col-sm-4 -->
            </div>


            <div class="page-header">
                <h1>Wells</h1>
            </div>

            <div class="well">
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras mattis consectetur purus sit amet fermentum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur.</p>
            </div>


            <div class="page-header">
                <h1>Carousel</h1>
            </div>

            <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
                <ol class="carousel-indicators">
                    <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                    <li data-target="#carousel-example-generic" data-slide-to="1"></li>
                    <li data-target="#carousel-example-generic" data-slide-to="2"></li>
                </ol>

                <div class="carousel-inner" role="listbox">
                    <div class="item active">
                        <img data-src="holder.js/1140x500/auto/#777:#555/text:First slide" alt="First slide">
                    </div>

                    <div class="item">
                        <img data-src="holder.js/1140x500/auto/#666:#444/text:Second slide" alt="Second slide">
                    </div>

                    <div class="item">
                        <img data-src="holder.js/1140x500/auto/#555:#333/text:Third slide" alt="Third slide">
                    </div>
                </div>
                <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>

        </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
        <script src="${resource(dir: 'js/jquery-ui-1.11.2/external/jquery', file: 'jquery.js')}"></script>
        <script src="${resource(dir: 'js/jquery-ui-1.11.2', file: 'jquery-ui.min.js')}"></script>
        <script src="${resource(dir: 'bootstrap-3.3.1/dist/js', file: 'bootstrap.min.js')}"></script>
    </body>
</html>
