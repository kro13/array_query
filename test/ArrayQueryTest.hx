package ;
import haxe.Json;
import haxe.unit.TestCase;

class ArrayQueryTest extends TestCase
{
    public function test1()
    {
        var arr:Array<MyType> = buildArray();
        var q = {val0: 0, val1: "1"};

        var items:Array<MyType> = ArrayQuery.match(arr, q);

        assertEquals(items.length, 1);
        assertEquals(items[0].val0, 0);
        assertEquals(items[0].val1, "1");
    }

    public function test2()
    {
        var arr:Array<MyType> = buildArray();
        var q = {val1: "0"};

        var items:Array<MyType> = ArrayQuery.match(arr, q);

        assertEquals(items.length, 0);
    }

    public function test3()
    {
        var arr:Array<MyType> = buildArray();
        var q = {val1: "1"};

        var items:Array<MyType> = ArrayQuery.match(arr, q);

        assertEquals(items.length, 2);
    }

    public function test4()
    {
        var arr:Array<MyType> = buildArray();

        var items:Array<MyType> = ArrayQuery.match(arr, {val0: 0, val1: "1", val3:0.5});

        assertEquals(items.length, 1);
    }

    public function test5()
    {
        var arr:Array<MyType> = buildArray();

        var items:Array<MyType> = ArrayQuery.match(arr, {val0: 3, val1: "1", val2:true});

        assertEquals(items.length, 1);
    }

    public function test6()
    {
        var arr:Array<MyType> = buildArray();

        var items:Array<MyType> = ArrayQuery.match(arr, {val0: 0, val1: "1", val2:false});

        assertEquals(items.length, 0);
    }

    public function test7()
    {
        var arr:Array<MyType> = buildArray();

        var items:Array<MyType> = ArrayQuery.match(arr, {val0: 0, val1: "1", val3:0.6});

        assertEquals(items.length, 0);
    }

    public function test8()
    {
        var arr:Array<MyType> = buildArray();

        var q = {val0: 0, val1: "1", val3:0.6};

        var items:Array<MyType> = ArrayQuery.match(arr, q);

        assertEquals(items.length, 0);
    }

    public function test9()
    {
        var arr:Array<MyClass> = [new MyClass(), new MyClass(), new MyClass()];
        arr[1].v = 2;

        var items:Array<MyClass> = ArrayQuery.match(arr, {v:1});

        assertEquals(items.length, 2);
    }

    public function test10()
    {
        var arr:Array<MyClass> = [new MyClass(), new MyClass(), new MyClass()];
        arr[1].v = 2;

        var items:Array<MyClass> = ArrayQuery.match(arr, {b:false});

        assertEquals(items.length, 3);
    }

    //TODO:
    /*public function test11()
    {
        var arr:Array<MyClass> = [new MyClass(), new MyClass(), new MyClass()];
        arr[1].v = 2;
        var q = Json.parse("{b:false}");

        var items:Array<MyClass> = ArrayQuery.match(arr, q);

        assertEquals(items.length, 3);
    }*/

    private function buildArray():Array<MyType>
    {
        return [{val0:10, val1:"2"}, {val0:0, val1:"1", val3:0.5}, {val0:3, val1:"1", val2:true}];
    }
}

typedef MyType = {
    var val0:Int;
    var val1:String;
    @:optional var val2:Bool;
    @:optional var val3:Float;
}

private class MyClass
{
    public var v:Int = 1;
    public var b:Bool = false;

    public function new ()
    {
        v = 1;
    }
}
