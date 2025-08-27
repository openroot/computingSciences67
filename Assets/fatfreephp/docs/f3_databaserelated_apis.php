<?php
/* ********************************************* */
/* Transactions */
/* ********************************************* */
// Danger: Passing string arguments to SQL statements is fraught with danger.
$db->exec(
    array(
        'DELETE FROM diet WHERE food="cola"',
        'INSERT INTO diet (food) VALUES ("carrot")',
        'SELECT * FROM diet'
    )
);
// Danger: Passing string arguments to SQL statements is fraught with danger.
$db->begin();
$db->exec('DELETE FROM diet WHERE food="cola"');
$db->exec('INSERT INTO diet (food) VALUES ("carrot")');
$db->exec('SELECT * FROM diet');
$db->commit();
// Parameterized queries help you mitigate SQL Injection.
$db->exec(
    array(
        'DELETE FROM diet WHERE food=:name',
        'INSERT INTO diet (food) VALUES (?)',
        'SELECT * FROM diet'
    ),
    array(
        array(':name'=>'cola'),
        array(1=>'carrot'),
        NULL
    )
);
// To get a list of all database instructions issued.
echo $db->log();

/* ********************************************* */
/* Parameterized Queries */
/* ********************************************* */
// Danger: Passing string arguments to SQL statements is fraught with danger.
$db->exec(
    'SELECT * FROM users '.
    'WHERE username="'.$f3->get('POST.userID').'"'
);
// Parameterized queries help you mitigate SQL Injection.
$db->exec(
    'SELECT * FROM users WHERE userID=?',
    $f3->get('POST.userID')
);

/* CRUD (But With a Lot of Style) */
$user=new DB\SQL\Mapper($db,'users');
$user->load(array('userID=?','tarzan'));
// Jig
$db=new DB\Jig('db/data/',DB\Jig::FORMAT_JSON);
$user=new DB\Jig\Mapper($db,'users');
$user->load(array('@userID=?','tarzan'));

/* The Smart SQL ORM */
$user=new DB\SQL\Mapper($db,'users'); // or $user=new DB\Jig\Mapper($db,'users');
$user->userID='jane';
$user->password=md5('secret');
$user->visits=0;
$user->save();

/* Caveat for SQL Tables */
$user=new DB\SQL\Mapper($db,'users');
$user->load(array('userID=? AND password=?','cheetah','ch1mp'));
$user->erase();
// Jig
$user=new DB\Jig\Mapper($db,'users');
$user->load(array('@userID=? AND @password=?','cheetah','chimp'));
$user->erase();

/* ********************************************* */
/* Beyond CRUD */
/* ********************************************* */
// Danger: By default, copyfrom takes the whole array provided. This may open a security leak if the user posts more fields than you expect. Use the 2nd parameter to setup a filter callback function to get rid of unwanted fields to copy from.
$f3->set('user',new DB\SQL\Mapper($db,'users'));
$f3->get('user')->copyFrom('POST');
$f3->get('user')->save();
$f3->set('user',new DB\SQL\Mapper($db,'users'));
$f3->get('user')->load(array('userID=?','jane'));
$f3->get('user')->copyTo('POST');
// We can then assign {{ @POST.userID }} to the same input field's value attribute. To sum up, the HTML input field will look like this:
// <input type="text" name="userID" value="{{ @POST.userID }}">
// The save(), update(), copyFrom() data mapper methods and the parameterized variants of load() and erase() are safe from SQL injection.

/* ********************************************* */

/* ********************************************* */
/* Navigation and Pagination */
/* ********************************************* */
$user=new DB\SQL\Mapper($db,'users');
$user->load('visits>3');
// Rewritten as a parameterized query
$user->load(array('visits>?',3)); // or (for Jig) $user->load('@visits>?',3);
// Display the userID of the first record that matches the criteria
echo $user->userID;
// Go to the next record that matches the same criteria
$user->skip(); // Same as $user->skip(1);
// Back to the first record
$user->skip(-1);
// Move three records forward
$user->skip(3);
// The load() method accepts a second argument: an array of options containing key-value pairs such as:
$user->load(
    array('visits>?',3),
    array(
        'order'=>'userID DESC',
        'offset'=>5,
        'limit'=>3
    )
); // translates to, "SELECT * FROM users WHERE visits>3 ORDER BY userID DESC LIMIT 3 OFFSET 5;"
// This is one way of presenting data in small chunks. Here's another way of paginating results:
// The actual subset position returned will be NULL if the first argument of paginate() is a negative number or exceeeds the number of subsets found.
$page=$user->paginate(2,5,array('visits>?',3));
/* ********************************************* */

/* ********************************************* */
/* Virtual Fields */
/* ********************************************* */
$item=new DB\SQL\Mapper($db,'products');
$item->totalprice='unitprice*quantity';
$item->load(array('productID=:pid',':pid'=>'apple'));
echo $item->totalprice;
// More complex virtual fields
$item->mostNumber='MAX(quantity)';
$item->load();
echo $item->mostNumber;

// Derive a value from another table
$item->supplierName=
    'SELECT name FROM suppliers '.
    'WHERE products.supplierID=suppliers.supplierID';
$item->load();
echo $item->supplierName;

/* ********************************************* */

/* ********************************************* */
/* Seek and You Shall Find */
/* ********************************************* */

// If you have no need for record-by-record navigation, you can retrieve an entire batch of records in one shot.
// If no records match the find() or select() criteria, the return value is an empty array.
// Keep in mind: load() hydrates the current mapper object, findone returns a new hydrated mapper object, and find returns an array of hydrated mapper objects.
//
// The find() method searches the users table for records that match the criteria,
// sorts the result by userID and returns the result as an array of mapper objects.
// find('visits>3') is different from load('visits>3').
// The latter refers to the current $user object. find() does not have any effect on skip().

// SQL
$frequentUsers=$user->find(array('visits>?',3),array('order'=>'userID'));
// Jig
$frequentUsers=$user->find(array('@visits>?',3),array('order'=>'userID'));

// find() syntax
find(
    $criteria,
    array(
        'group'=>'foo',
        'order'=>'foo,bar',
        'limit'=>5,
        'offset'=>0
    )
);
// find() returns an array of objects. Each object is a mapper to a record that matches the specified criteria.
$place=new DB\SQL\Mapper($db,'places');
$list=$place->find('state="New York"');
foreach ($list as $obj) {
    echo $obj->city.', '.$obj->country;
}
// If you need to convert a mapper object to an associative array, use the cast() method.
$array=$place->cast();
echo $array['city'].', '.$array['country'];
// To retrieve the number of records in a table that match a certain condition, use the count() method.
if (!$user->count(array('visits>?',10))) {
    echo 'We need a better ad campaign!';
}
// There's also a select() method that's similar to find() but provides more fine-grained control over fields returned. It has a SQL-like syntax:
select(
    'foo, bar, baz',
    'foo > ?',
    array(
        'group'=>'foo, bar',
        'order'=>'baz ASC',
        'limit'=>5,
        'offset'=>3
    )
);

/* ********************************************* */

/* ********************************************* */
/* Pros & Cons */
/* ********************************************* */
// SQL view created inside your database engine
// Your application code becomes simple because it does not have to maintain two mapper objects (one for the projects table and another for users) just to retrieve data from two joined tables:
/*
CREATE VIEW combined AS
SELECT
    projects.project_id AS project,
    users.name AS name
FROM projects
LEFT OUTER JOIN users ON
    projects.project_id=users.project_id AND
    projects.user_id=users.user_id;
*/
$combined=new DB\SQL\Mapper($db,'combined');
$combined->load(array('project=?',123));
echo $combined->name;

/* ********************************************* */


/* ********************************************* */
/* Added functionality to Mapper. Sometimes It Just Ain't Enough */
/* ********************************************* */
class Vendor extends DB\SQL\Mapper {
	// Instantiate mapper
	function __construct(DB\SQL $db) {
		// This is where the mapper and DB structure synchronization occurs
		parent::__construct($db,'vendors');
	}

	// Specialized query
	function listByCity() {
		return $this->select('vendorID,name,city',null,array('order'=>'city DESC'));
		/*
		We could have done the same thing with plain vanilla SQL:
		return $this->db->exec(
			'SELECT vendorID,name,city FROM vendors '.
			'ORDER BY city DESC;'
		);
		*/
	}
}

$vendor=new Vendor;
$vendor->listByCity();

/* ********************************************* */
