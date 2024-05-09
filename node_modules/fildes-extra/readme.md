# Fildes Extra


[![Build Status](https://img.shields.io/travis/thisconnect/fildes-extra/master.svg?style=flat-square&maxAge=1800)](https://travis-ci.org/thisconnect/fildes-extra)
[![Dependencies](https://img.shields.io/david/thisconnect/fildes-extra.svg?style=flat-square&maxAge=1800)](https://david-dm.org/thisconnect/fildes-extra)
[![Dev Dependencies](https://img.shields.io/david/dev/thisconnect/fildes-extra.svg?style=flat-square&maxAge=1800)](https://david-dm.org/thisconnect/fildes-extra?type=dev)

Extends [fildes](https://github.com/thisconnect/fildes) with `glob`, `cpy`, `rimraf` and `trash`/`empty-trash`.


### Install

```bash
npm i --save fildes-extra
```


### Examples

```javascript
var files = require('fildes-extra');

// make dir
files.mkdir('./a/new/dir')
.then(function(){
    // remove dir
    return files.rmdir('./a/new');
})
.then(function(){
    // copy dir
    return files.copy(['./a'], './b');
})
.then(function(){
    console.log('done!');
})
.catch(function(error){
    console.error(error);
})

```


### find (pattern)

Promise `fildes.find` alias `fildes.glob`
uses [glob](https://www.npmjs.com/package/glob) (NPM Documentation).

```javascript
fildes.find('**/*.{jpg,png}')
.then(function(images){
    console.log('found', images.length, 'images')
})
```


### rm (path)

Promise `fildes.rm` alias `fildes.rmdir`
uses [rimraf](https://www.npmjs.com/package/rimraf) (NPM Documentation).

```javascript
fildes.rm('./path/to/dir')
.then(function(){
    console.log('directory removed!');
});
```


### copy (files, destination, [options])

Promise `fildes.cp` alias `fildes.copy` uses [cpy](https://www.npmjs.com/package/cpy) (NPM Documentation).

```javascript
fildes.cp(['./data/*.txt'], './destination')
.then(function(){
    console.log('directory copied!');
});
```


### trash (files)

Promise `trash` uses [trash](https://www.npmjs.com/package/trash) (NPM Documentation).

```javascript
fildes.trash(['./data/file.txt'])
.then(function(){
    console.log('directory copied!');
});
```


### emptyTrash ()

Promise `empty-trash` uses [empty-trash](https://www.npmjs.com/package/empty-trash) (NPM Documentation).

```javascript
fildes.emptyTrash()
.then(function(){
    console.log('trash emptied!');
});
```


### Test

*WARNING:* tests will empty your trash!

```bash
npm test

# debug all
DEBUG=fildes* npm test
```
