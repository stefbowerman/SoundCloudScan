// include gulp
var gulp = require('gulp');

// include plug-ins
var jshint      = require('gulp-jshint');
var gulpif      = require('gulp-if');
var gutil       = require('gulp-util');
var sass        = require('gulp-sass');
var minCSS      = require('gulp-minify-css');
var rename      = require('gulp-rename');
var coffee      = require('gulp-coffee');
var uglify      = require('gulp-uglify');
var concat      = require('gulp-concat');
var browserSync = require('browser-sync');

var appRoot = '.';

var paths = {
  sass: appRoot + '/src/scss/**/*.scss',
  scripts: appRoot + '/src/scripts/**/*',
  build: appRoot + '/build/'
};

// JS hint task
// gulp.task('jshint', function() {
//   gulp.src('./src/scripts/*.js')
//     .pipe(jshint())
//     .pipe(jshint.reporter('default'));
// });

// Compile SCSS + Minify output
gulp.task('sass', function(){
  gulp.src(appRoot + '/src/scss/app.scss')
    .pipe(sass())
    .pipe(minCSS())
    .pipe(rename('app.min.css'))
    .pipe(gulp.dest(paths.build))
    .pipe(browserSync.reload({stream:true, once:true}));

    // console.log('Finished compiling sass');
});

// Compile coffeescripts, minify and concat with javascripts
gulp.task('scripts', function(){
    gulp.src(paths.scripts)
    .pipe(gulpif(/[.]coffee$/, coffee({bare:true}).on('error', gutil.log)))
    // .pipe(uglify())
    .pipe(concat('app.min.js'))
    .pipe(gulp.dest(paths.build))
    .pipe(browserSync.reload({stream:true, once:true}));
});

gulp.task('browser-sync', function(){
  browserSync.init(null, {
    server: {
      baseDir: "./"
    }
  });
});

// Reload all Browsers
gulp.task('bs-reload', function () {
    browserSync.reload();
});

gulp.task('default', ['browser-sync'], function(){
    gulp.watch(paths.scripts, ['scripts']);
    gulp.watch(paths.sass, ['sass']);
    gulp.watch("*.html", ['bs-reload']);
});
