import { MongoClient } from 'mongodb';

const url = "mongodb://127.0.0.1:27017";;
const client = new MongoClient(url);

const dbName = 'noSQL';

async function main() {
  await client.connect();
  console.log('Connected successfully to server');
  
  const db = client.db(dbName);

  console.log('');
  console.log('=== 1 ===');
  console.log('Make some colletions');
  const Products = db.collection('Products');
  const Inventory = db.collection('Inventory');
  const Orders = db.collection('Orders');

  console.log('');
  console.log('=== 2 ===');
  await Products.insertMany([
    {
        _id: 1,
        product_name: "Laptop",
        category: "Elektronik",
        price: 999.99
    }, 
    {
        _id: 2,
        product_name: "Meja Kursi",
        category: "Perabot",
        price: 199.99
    },
    {
        _id: 3,
        product_name: "Printer",
        category: "Elektronik",
        price: 299.99
    },
    {
        _id: 4,
        product_name: "Rak Buku",
        category: "Perabot",
        price: 149.99
    }
  ]).then(result => console.log(result));


  console.log('');
  console.log('=== 3 ===');
  const three = await Products.find().sort({price: 1}).toArray();
  console.log(three);

  console.log('');
  console.log('=== 4 ===');
  await Inventory.insertMany([
    {
      _id: 1,
      product_id: 1,
      quantity: 50,
      location: "Gudang A"
    },
    {
      _id: 2,
      product_id: 2,
      quantity: 30,
      location: "Gudang B"
    },
    {
      _id: 3,
      product_id: 3,
      quantity: 20,
      location: "Gudang A"
    },
    {
      _id: 4,
      product_id: 4,
      quantity: 40,
      location: "Gudang B"
    }
  ]).then(result => console.log(result));


  console.log('');
  console.log('=== 5 ===');

  const five = await Inventory.aggregate([
    {
      $lookup:
        {
          from: "Products",
          localField: "product_id",
          foreignField: "_id",
          as: "product_info"
        }
    },
    {
      $unwind: "$product_info"
    },
    {
      $project: {
        _id: 0,
        product_name: "$product_info.product_name",
        quantity: 1,
        location: 1
      }
    }
  ]).toArray();
  console.log(five);
  

  console.log('');
  console.log('=== 6 ===');

  const six = await Products.updateOne({product_name: "Laptop"}, {$set: {price: 1099.99}});
  console.log(six);


  console.log('');
  console.log('=== 7 ===');

  const seven = await Inventory.aggregate([
    {
      $lookup:{
        from: "Products",
        localField: "product_id",
        foreignField: "_id",
        as: "product_info"
      }
    },
    {
      $unwind: "$product_info"
    },
    {
      $addFields: {
        subtotal: { $multiply: ["$quantity", "$product_info.price"]}
      }
    },
    {
      $group: {
        _id: "$location",
        total_value: { $sum: "$subtotal" }
      }
    },
    {
      $project: {
        _id: "$_id",
        total_value: 1
      }
    }
  ]).toArray();
  console.log(seven);


  console.log('');
  console.log('=== 8 ===');
  
  await Orders.insertMany([
    {
      _id: 1,
      customer_id: 101,
      order_date: new Date("2024-08-12"),
      order_details: [
        { product_id: 1, quantity: 2 },
        { product_id: 3, quantity: 1 }
      ]
    },
    {
      _id: 2,
      customer_id: 102,
      order_date: new Date("2024-08-13"),
      order_details: [
        { product_id: 2, quantity: 1 },
        { product_id: 4, quantity: 2 }
      ]
    }
  ]).then(result => console.log(result));


  console.log('');
  console.log('=== 9 ===');

  const nine = await Orders.aggregate([
    {
      $unwind: "$order_details"
    },
    {
      $lookup: {
        from: "Products",
        localField: "order_details.product_id",
        foreignField: "_id",
        as: "products_info"
      }
    },
    {
      $unwind: "$products_info"
    },
    {
      $addFields : {
        product_amount: { $multiply: ["$order_details.quantity", "$products_info.price"]}
      }
    },
    {
      $group: {
        _id: "$_id",
        total_amount: { $sum: "$product_amount" },
        order_date: { $first: "$order_date" } 
      }
    },
    {
      $project: {
        _id: 0,
        order_id: "$_id",
        order_date: 1,
        total_amount: "$total_amount"
      }
    }
  ]).toArray();
  console.log(nine);


  console.log('');
  console.log('=== 10 ===');

  const ten = await Products.aggregate([
    {
      $lookup: {
        from: "Orders",
        localField: "_id",
        foreignField: "order_details.product_id",
        as: "product_info"
      }
    },
    {
      $match: {
        product_info: { $eq: [] }
      }
    },
    {
      $project: {
        _id: 1,
        product_name: 1
      }
    }
  ]).toArray();
  console.log(ten);
  

  return 'done.';
}

main()
  .then(console.log)
  .catch(console.error)
  .finally(() => client.close());