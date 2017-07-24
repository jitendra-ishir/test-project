<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
            <style type="text/css">
                /* Makes images fully responsive */
                .img-responsive,
                .thumbnail > img,
                .thumbnail a > img,
                .carousel-inner > .item > img,
                .carousel-inner > .item > a > img {
                    display: block;
                    width: 500px;
                    height: 100px;
                }
                /* ------------------- Carousel Styling ------------------- */
                .carousel-inner {
                    border-radius: 15px;
                }
                .carousel-caption {
                    background-color: rgba(0,0,0,.5);
                    position: absolute;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    z-index: 10;
                    padding: 0 0 10px 25px;
                    color: #fff;
                    text-align: left;
                }
                .carousel-indicators {
                    position: absolute;
                    bottom: 0;
                    right: 0;
                    left: 0;
                    width: 100%;
                    z-index: 15;
                    margin: 0;
                    padding: 0 25px 25px 0;
                    text-align: right;
                }
                .carousel-control.left,
                .carousel-control.right {
                    background-image: none;
                }
                /* ------------------- Section Styling - Not needed for carousel styling ------------------- */
                .section-white {
                    padding: 10px 0;
                }
                .section-white {
                    background-color: #fff;
                    color: #555;
                }
                @media screen and (min-width: 768px) {

                    .section-white {
                        padding: 1.5em 0;
                    }

                }
                @media screen and (min-width: 992px) {

                    .container {
                        max-width: 930px;
                    }

                }
            </style>
            <script src="//code.jquery.com/jquery-1.10.2.min.js"></script>
            <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
    </head>
    <body>
        <section class="section-white">
            <div class="container">
                <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">

                    <!-- Wrapper for slides -->
                    <div class="carousel-inner">
                        <div class="item active">
                                <div class="carousel-caption">
                                    <h2>Heading</h2>
                                </div>
                        </div>
                        <div class="item">
                                <div class="carousel-caption">
                                    <h2>Heading</h2>
                                </div>
                        </div>
                        <div class="item">
                                <div class="carousel-caption">
                                    <h2>Heading</h2>
                                </div>
                        </div>
                    </div>

                    <!-- Controls -->
                    <a class="left carousel-control" href="#carousel-example-generic" data-slide="prev">
                        <span class="glyphicon glyphicon-chevron-left"></span>
                    </a>
                    <a class="right carousel-control" href="#carousel-example-generic" data-slide="next">
                        <span class="glyphicon glyphicon-chevron-right"></span>
                    </a>
                </div>
            </div>
        </section>
    </body>
</html>