<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<base href="/resources/">
<title>Login</title>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Favicon -->
  <link rel="icon" href="/resources/img/brand/favicon.png" type="image/png">
  <!-- Fonts -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700">
  <!-- Icons -->
  <link rel="stylesheet" href="/resources/vendor/nucleo/css/nucleo.css" type="text/css">
  <link rel="stylesheet" href="/resources/vendor/@fortawesome/fontawesome-free/css/all.min.css" type="text/css">
  <!-- Argon CSS -->
  <link rel="stylesheet" href="/resources/css/argon.css?v=1.2.0" type="text/css">
</head>

<body class="bg-default">
  <!-- Navbar -->
  <nav id="navbar-main" class="navbar navbar-horizontal navbar-transparent navbar-main navbar-expand-lg navbar-light">
    <div class="container">
      <a class="navbar-brand">
      </a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar-collapse" aria-controls="navbar-collapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="navbar-collapse navbar-custom-collapse collapse" id="navbar-collapse">
        <div class="navbar-collapse-header">
          <div class="row">
            <div class="col-6 collapse-brand">
              <a href="dashboard.html">
                <img src="/resources/img/brand/blue.png">
              </a>
            </div>
            <div class="col-6 collapse-close">
              <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbar-collapse" aria-controls="navbar-collapse" aria-expanded="false" aria-label="Toggle navigation">
                <span></span>
                <span></span>
              </button>
            </div>
          </div>
        </div>
        <ul class="navbar-nav mr-auto">
          <li class="nav-item">
            <a href="dashboard.html" class="nav-link">
              <span class="nav-link-inner--text">Dashboard</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="/member/login" class="nav-link">
              <span class="nav-link-inner--text">Login</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="/member/register" class="nav-link">
              <span class="nav-link-inner--text">Register</span>
            </a>
          </li>
        </ul>
        <hr class="d-lg-none" />
        <ul class="navbar-nav align-items-lg-center ml-lg-auto">
         
          <li class="nav-item">
            <a class="nav-link nav-link-icon" href="https://www.instagram.com/creativetimofficial" target="_blank" data-toggle="tooltip" data-original-title="Follow us on Instagram">
              <i class="fab fa-instagram"></i>
              <span class="nav-link-inner--text d-lg-none">Instagram</span>
            </a>
          </li>
          
        </ul>
      </div>
    </div>
  </nav>
  <!-- Main content -->
  <div class="main-content">
    <!-- Header -->
    <div class="header bg-gradient-primary py-7 py-lg-8 pt-lg-9">
      <div class="container">
        <div class="header-body text-center mb-5">
          <div class="row justify-content-center">
            <div class="col-xl-5 col-lg-6 col-md-8 px-5">
              <h1 class="text-white">Create New Account</h1>
            </div>
          </div>
        </div>
      </div>
     
    </div>
    <!-- Page content -->
    <div class="container mt--8 pb-5">
      <!-- Table -->
      <div class="row justify-content-center">
        <div class="col-lg-6 col-md-8">
          <div class="card bg-secondary border-0">
            
            <div class="card-body px-lg-5 py-lg-5">
              
              <form role="form" action="/member/registerPost" method="post">
              
              
                 <div class="form-group">
                  <div class="input-group input-group-merge input-group-alternative mb-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text"><i class="ni ni-user-run"></i></span>
                    </div>
                    <input class="form-control" placeholder="ID" name="memberId" type="text">
                  </div>
                 </div>
              	 <div class="form-group">
                  <div class="input-group input-group-merge input-group-alternative">
                    <div class="input-group-prepend">
                      <span class="input-group-text"><i class="ni ni-lock-circle-open"></i></span>
                    </div>
                    <input class="form-control" placeholder="Password" name="memberPW" type="password">
                  </div>
                </div>
                <div class="form-group">
                  <div class="input-group input-group-merge input-group-alternative mb-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text"><i class="fas fa-address-card"></i></span>
                    </div>
                    <input class="form-control" placeholder="Name" name="memberName" type="text">
                  </div>
                </div>
                
                <div class="form-group">
                  <div class="input-group input-group-merge input-group-alternative mb-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text"><i class="ni ni-email-83"></i></span>
                    </div>
                    <input class="form-control" placeholder="Email" name="memberEmail" type="email">
                  </div>
                </div>
                
                <div class="form-group">
                  	<div class="input-group input-group-merge input-group-alternative mb-3">
                  	 <div class="input-group-prepend">
                      <span class="input-group-text"><i class="fas fa-venus-mars"></i></span>
                    </div>
					    <select class="form-control" name="memberGender" id="exampleFormControlSelect1">
					      <option value="M">남자</option>
					      <option value="F">여자</option>
					    </select>
                	</div>
                </div>
                
                <div class="form-group">Birth Day
	                 <div class="input-daterange datepicker row align-items-center mb-3 input-group-merge">
					    <div class="col">
				            <div class="input-group"> 
				                <div class="input-group-prepend">
				                    <span class="input-group-text"><i class="fas fa-birthday-cake"></i></span>
				                </div>
				                <input class="form-control" placeholder="Birth Day" name="memberBirth" type="text" value="01/01/2000">
				            </div>
					    </div>
					</div>
                </div>
              
                <div class="text-center">
                  <button type="submit" class="btn btn-primary mt-4">Create account</button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- Argon Scripts -->
  <!-- Core -->
  <script src="/resources/vendor/jquery/dist/jquery.min.js"></script>
  <script src="/resources/vendor/bootstrap/dist/js/bootstrap.bundle.min.js"></script>
  <script src="/resources/vendor/js-cookie/js.cookie.js"></script>
  <script src="/resources/vendor/jquery.scrollbar/jquery.scrollbar.min.js"></script>
  <script src="/resources/vendor/jquery-scroll-lock/dist/jquery-scrollLock.min.js"></script>
  <script src="/resources/vendor/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
  <!-- Argon JS -->
  <script src="/resources/js/argon.js?v=1.2.0"></script>
</body>

</html>