/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Andrew Salomatin (MerlinDS)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package org.gimmick.utils
{

	/**
	 * Generate and return unique id
	 */
	public function getUniqueId():String
	{
		return UniqueIdHelper.getUniqueId;
	}
}
class UniqueIdHelper
{
	public static var _existingIds:Vector.<String>;

	public static function get getUniqueId():String
	{
		if(_existingIds == null)
			_existingIds = new <String>[];
		var uniqueId:String = "";
		var date:String = new Date().time.toString();
		var n:int = date.length / 2;
		for(var i:int = 0; i < n; ++i)
		{
			var chunk:int = int( date.charAt(i) + date.charAt(i + 1) );
			uniqueId += chunk.toString(16).toUpperCase();
		}
		while(_existingIds.indexOf(uniqueId) >= 0)
			uniqueId = int(Math.random() * 1024).toString(16).toUpperCase() + uniqueId;//TODO fix this
		_existingIds[_existingIds.length] = uniqueId;
		return uniqueId;
	}

}