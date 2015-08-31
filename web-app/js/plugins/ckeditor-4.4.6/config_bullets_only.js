/*
 Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function (config) {
    config.language = 'es';
    config.uiColor = '#AABBCC';

    config.height = '220px';

    config.toolbar = 'Min';
    config.resizable = false;
    config.toolbar_Min =
    [
        {name : 'paragraph', items : ['NumberedList', 'BulletedList']},
        {name : 'about', items : ['About']}
    ];
};
