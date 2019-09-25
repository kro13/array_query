package ;
import haxe.macro.Expr.ExprOf;
import Array;
import haxe.macro.Expr.ExprOf;
import haxe.EnumTools.EnumValueTools;
import haxe.macro.Expr.ExprOf;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
class ArrayQuery
{

    public static macro function match<T>(collection:ExprOf<Array<T>>, query:Expr):Expr
    {
        var itemFields:Array<String> = getFields(collection);
        var matchImpl:Expr = matchMacro(itemFields, query);
        return macro {
            function()
            {
                for (item in $collection)
                {
                    if ($matchImpl)
                    {
                        return item;
                    }
                }

                return null;
            }();

        }
    }

    public static function matchMacro(itemFields:Array<String>, query:Expr):Expr
    {
        #if macro
        var queryFields:Array<String> = getFields(query);
        var queryName:String = getVarName(query);

        var checks:Array<String> = [];

        for (qF in queryFields)
        {
            if (itemFields.indexOf(qF) < 0)
            {
                return macro $v{false};
            }
            else
            {
                var checkStr:String = 'item.${qF} == ${queryName}.${qF}';
                trace(checkStr);
                checks.push(checkStr);
            }
        }

        var allChecksStr:String = "";
        var i:Int = 0;
        for (check in checks)
        {
            allChecksStr += check;
            if (i < checks.length - 1)
            {
                allChecksStr += " && ";
            }
            i++;
        }

        trace(allChecksStr);

        return Context.parse(allChecksStr, Context.currentPos());
        #else
        return null;
        #end
    }

    public static /*macro*/ function matchMacro1(item:Expr, query:Expr):Expr
    {
        #if macro
        var itemName:String = getVarName(item);
        var queryName:String = getVarName(query);

        var itemFields:Array<String> = getFields(item);
        var queryFields:Array<String> = getFields(query);

        var checks:Array<String> = [];

        for (qF in queryFields)
        {
            if (itemFields.indexOf(qF) < 0)
            {
                return macro $v{false};
            }
            else
            {
                var checkStr:String = '${itemName}.${qF} == ${queryName}.${qF}';
                trace(checkStr);
                checks.push(checkStr);
            }
        }

        var allChecksStr:String = "";
        var i:Int = 0;
        for (check in checks)
        {
            allChecksStr += check;
            if (i < checks.length - 1)
            {
                allChecksStr += " && ";
            }
            i++;
        }

        trace(allChecksStr);

        return Context.parse(allChecksStr, Context.currentPos());
        #else
        return null;
        #end
    }

    public static function getVarName(expr:Expr):String
    {
        #if macro
        var varName:String = "";

        switch (expr.expr)
        {
            case EConst(CIdent(name)):
                varName = name;

            default:
                throw('unsupported expr ${expr.expr}');
        }

        return varName;
        #else
        return null;
        #end
    }

    public static function getFields(expr:Expr):Array<String>
    {
        #if macro
        var t:Type = Context.typeof(expr);
        trace(expr);
        trace(t);
        trace(Context.follow(t));

        var fieldNames:Array<String> = [];

        switch (Context.follow(t))
        {
            case TAnonymous(ref):
                //trace(ref.get().fields);
                var fields:Array<ClassField> = ref.get().fields;
                for (f in fields)
                {
                    //trace('${f.name}');
                    fieldNames.push(f.name);
                }
            case TInst(ref, [TType(type, params)]) if (ref.toString() == "Array"):
                switch(Context.follow(type.get().type))
                {
                    case TAnonymous(ref):
                        //trace(ref.get().fields);
                        var fields:Array<ClassField> = ref.get().fields;
                        for (f in fields)
                        {
                            //trace('${f.name}');
                            fieldNames.push(f.name);
                        }
                    default:
                 }


            case TInst(ref, params):
                trace(ref);
                //trace(ref.get().fields.get());
                var fields:Array<ClassField> = ref.get().fields.get();
                for (f in fields)
                {
                    //trace('${f.name}');
                    fieldNames.push(f.name);
                }

            default:
                throw('unsupported object ${t}');
        }

        return fieldNames;
        #else
        return null;
        #end
    }

}

