const gulp = require('gulp');
const sass = require('gulp-sass');
const babel = require('gulp-babel');
const sourceMaps = require('gulp-sourcemaps');
const concat = require('gulp-concat');
const uglify = require('gulp-uglify');
const htmlMin = require('gulp-htmlmin');
const embedTemplates = require('gulp-angular-embed-templates');
const sassGlob = require('gulp-sass-glob');
const historyApiFallback = require('connect-history-api-fallback');

const mergeLangFiles = require('./gulp/mergeLangFiles');

const srcDir = './src/';
const assetsDir = './assets';
const distDir = './dist';
const distAssetsDir = './dist/assets';
const nodeModulesDir = './node_modules/';

const browserSync = require('browser-sync').create();


gulp.task('compile', compile(null, {
  runWatchers: false,
  browserSync: {
    host: '0.0.0.0',
    port: 5000
  }
}));

const devOptions = {
  runWatchers: true,
  gzip: false,
  minimize: false,
  browserSync: {port: 5000}
};

gulp.task('default', gulp.series([
  compile(browserSync, devOptions),
  watch(browserSync, devOptions)
]));

function compile(browserSync, options, modules) {
  options = Object.assign({}, {
    minimize: true
  }, options);

  const tasks = [
    // Vendors

    vendorsMerge(options),
    vendorsStyleMerge(options),

    // App Code
    angularAppMerge(options),

    // Styles
    sassCompile(browserSync, options),

    // Other Files
    minifyIndex(),
    langFilesMerge,
    moveFonts,
    moveImages,
    moveSamples,
    moveFavicon
  ];

  return gulp.parallel(tasks);
}

function watch(browserSync, options) {
  options = Object.assign({}, {
    port: 8080,
    open: false,
    ui: false,
    server: {
      baseDir: distDir,
      middleware: [
        historyApiFallback()
      ]
    }
  }, options.browserSync);
  return function watch() {
    browserSync.init(options);

    gulp.watch(angularAppWatchSrc(), angularAppMerge(options));
    gulp.watch(sassWatchSrc(), sassCompile(browserSync, options));
    gulp.watch(langFilesWatchSrc(), langFilesMerge);
    gulp.watch(['./src/index.html'], minifyIndex());

    gulp.watch([
      distDir + '/index.html',
      distDir + '/assets/js/**/*.js'
    ], function refreshBrowser(done) {
      browserSync.reload();
      done();
    });
  };
}

function vendorsMerge(options) {
  return function vendorsMerge() {
    const task = gulp
      .src([
        nodeModulesDir + 'jquery/dist/jquery.min.js',
        nodeModulesDir + 'moment/min/moment.min.js',
        nodeModulesDir + 'angular/angular.min.js',

        nodeModulesDir + 'angular-sanitize/angular-sanitize.min.js',
        nodeModulesDir + 'angular-storage/dist/angular-storage.min.js',
        nodeModulesDir + 'bootstrap-ui-datetime-picker/dist/datetime-picker.min.js',
        nodeModulesDir + '@uirouter/angularjs/release/angular-ui-router.min.js',
        nodeModulesDir + 'datatables.net/js/jquery.dataTables.js',
        nodeModulesDir + 'datatables.net-bs/js/dataTables.bootstrap.js',
        nodeModulesDir + 'datatables.net-responsive/js/dataTables.responsive.js',
        nodeModulesDir + 'datatables.net-responsive-bs/js/responsive.bootstrap.js',
        nodeModulesDir + 'angular-translate/dist/angular-translate.min.js',
        nodeModulesDir + 'angular-translate-loader-static-files/angular-translate-loader-static-files.min.js',
        nodeModulesDir + 'ui-select/dist/select.min.js',
        nodeModulesDir + 'angular-ui-bootstrap/dist/ui-bootstrap-tpls.js',
        nodeModulesDir + 'echarts/dist/echarts.min.js',
        assetsDir + '/js/echarts-theme.js'
      ])
      .pipe(concat({path: 'vendors.min.js'}))
      .pipe(gulp.dest(distAssetsDir + '/js/vendors'));

    task.on('error', function (err) {
      console.log(err);
    });

    return task;
  };
}

function vendorsStyleMerge(options) {
  return function vendorsStyleMerge() {
    const task = gulp
      .src([
        nodeModulesDir + 'ui-select/dist/select.min.css',
        nodeModulesDir + 'datatables.net-bs/css/dataTables.bootstrap.css',
        nodeModulesDir + 'datatables.net-responsive-bs/css/responsive.bootstrap.min.css'
      ])
      .pipe(concat({path: 'vendors.min.css'}))
      .pipe(gulp.dest(distAssetsDir + '/css'));

    task.on('error', function (err) {
      console.log(err);
    });

    return task;
  };
}

function angularAppMerge(options) {
  return function angularAppMerge() {
    const task = gulp
      .src([
        srcDir + 'app/_app.js',
        srcDir + 'app/*.js',
        srcDir + 'app/**/*.js'
      ])
      .pipe(embedTemplates())
      .pipe(sourceMaps.init())
      .pipe(babel({
        presets: ['@babel/preset-env'],
        comments: false
      }))
      .pipe(concat({path: 'app.min.js'}));

    if (options.minimize) {
      task.pipe(uglify());
    }

    task.pipe(sourceMaps.write('maps'))
      .pipe(gulp.dest(distAssetsDir + '/js/app'))
      .on('error', function (err) {
        console.log(err);
      });

    return task;
  };
}

function angularAppWatchSrc() {
  return [
    srcDir + 'app/*.js',
    srcDir + 'app/*.html',
    srcDir + 'app/**/*.js',
    srcDir + 'app/**/*.html'
  ];
}

function sassCompile(browserSync, options) {
  return function sassCompile() {
    const task = gulp
      .src([srcDir + 'style.scss'])
      .pipe(sassGlob())
      .pipe(sourceMaps.init())
      .pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
      .pipe(sourceMaps.write('maps'))
      .pipe(gulp.dest(distAssetsDir + '/css'));

    if (browserSync) {
      task.pipe(browserSync.stream({match: '**/*.css'}));
    }

    return task;
  };
}

function sassWatchSrc() {
  return [
    assetsDir + '/sass/*.scss',
    assetsDir + '/sass/**/*.scss',
    srcDir + '**/*.scss'
  ];
}

function minifyIndex() {
  return function minifyIndex() {
    return gulp
      .src(['./src/index.html'])
      .pipe(htmlMin({collapseWhitespace: true, minifyJS: true, removeComments: false}))
      .pipe(gulp.dest(distDir));
  };
}

function langFilesMerge() {
  return gulp
    .src([srcDir + '**/lang/*.json', srcDir + '**/lang/**/*.json'])
    .pipe(mergeLangFiles())
    .pipe(gulp.dest(distAssetsDir + '/lang'));
}

function langFilesWatchSrc() {
  return [srcDir + '**/lang/*.json', srcDir + '**/lang/**/*.json'];
}

function moveFonts() {
  return gulp
    .src([nodeModulesDir + '@fortawesome/fontawesome-free/webfonts/**'])
    .pipe(gulp.dest(distAssetsDir + '/fonts/'));
}

function moveImages() {
  return gulp
    .src([assetsDir + '/images/**'])
    .pipe(gulp.dest(distAssetsDir + '/images/'));
}

function moveSamples() {
  return gulp
    .src([assetsDir + '/samples/**'])
    .pipe(gulp.dest(distAssetsDir + '/samples/'));
}

function moveFavicon() {
  return gulp
    .src([assetsDir + '/favicon/**'])
    .pipe(gulp.dest(distAssetsDir + '/favicon/'));
}