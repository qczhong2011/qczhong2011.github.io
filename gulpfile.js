/**
 * Created by Zingqi on 2018/4/12.
 */
var gulp = require('gulp');
var minifycss = require('gulp-minify-css');
var uglify = require('gulp-uglify');
var htmlmin = require('gulp-htmlmin');
var htmlclean = require('gulp-htmlclean');

var option = {
    removeComments: true,  //清除HTML注释
    collapseWhitespace: false,  //压缩HTML,会导致相册页面排版不好看
    collapseBooleanAttributes: true,  //省略布尔属性的值 <input checked="true"/> ==> <input checked />
    removeEmptyAttributes: true,  //删除所有空格作属性值 <input id="" /> ==> <input />
    removeScriptTypeAttributes: true,  //删除<script>的type="text/javascript"
    removeStyleLinkTypeAttributes: true,  //删除<style>和<link>的type="text/css"
    minifyJS: true,  //压缩页面JS
    minifyCSS: true  //压缩页面CSS
};

// 获取 gulp-imagemin 模块
var imagemin = require('gulp-imagemin');

// 压缩 public 目录 css
gulp.task('minify-css', function() {
    return gulp.src('./public/**/*.css')
        .pipe(minifycss())
        .pipe(gulp.dest('./public'));
});
// 压缩 public 目录 html
gulp.task('minify-html', function() {
    return gulp.src('./public/**/*.html')
        .pipe(htmlmin(option))
        .on('error', function(err) {
            console.log('html Error!', err.message);
            this.end();
        })
        .pipe(gulp.dest('./public'))
});
// 压缩 public/js 目录 js
gulp.task('minify-js', function() {
    return gulp.src('./public/**/*.js')
        .pipe(uglify())
        .pipe(gulp.dest('./public'));
});


// 压缩图片任务
// 在命令行输入 gulp images 启动此任务
gulp.task('images', function () {
    // 1. 找到图片
    gulp.src('./images/*.*')
    // 2. 压缩图片
        .pipe(imagemin({
            progressive: true
        }))
        // 3. 另存图片
        .pipe(gulp.dest('dist/images'))
});

// 执行 gulp 命令时执行的任务
gulp.task('build', [
    'minify-html','minify-css','minify-js','images',
]);
