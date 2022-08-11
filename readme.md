# Yimmerce Web Applicaion

### Video Demo :

### Description:

This is an E-commerce web application which is build
by using Python Flask as backend, and
simple HTML, CSS, and JS at frontend. MySQL is the backbone in this web application,
which it acts as a database for me to access and manage data.

This web application help both user and seller to gain a lot of advantages, which
the most importance thing is the buying/selling products. By using this web application,
all the tedious process such as recording down the order details manually on
a book can be eliminated. What's more is that, there are plenty of useful features, such as
a live chat between user and seller, vouchers for discounting price, and user wallet for paying.
<hr/>

#### User:

There are many operations can be performed by this role. User can make an order through this web application, checking
the product at the main page,
filter product result by the product name, adding product items into cart, and placing order.

Furthermore, users can also check their purchase history, have a live chat with the seller, and
check the notifications such as placing a successful order, or
after changing his/her password. 

Moreover, the users can also rate the order list of the orders, which can provide
feedback, and also a better consideration for other potential buyers. After rating, the users can also view back their
previous ratings as well. 

Last but not least, it's the wallet feature.
User can deposit or withdraw money to/from the wallet. On the payment window, user can choose wallet
as a payment option as well. Note that this the process of withdrawal or deposit is not engaged with real
payment gateway, it's sorely made for this project virtually only.
<hr/>

#### Seller:

Seller is privileged to perform almost all the CRUD (Create, Read, Update, Delete) available such
as products and vouchers. In this web application, everything
is automated, in which seller is not needed to involve in the buying process except
answering enquires from the potential buyers.

All the orders, will be automatically recorded, and
seller can update the shipment status when it is ready, shipped, or delivered. Besides, a CRUD on
products is pretty essential for an E-commerce web application too. Thus, I have implemented
to let seller creating product, updating product, and deleting product comfortably by using Bootstrap Modal.
Seller can update a product, in which the modal will automatically fill up all the previous details of the product,
where seller only need to make a bit of change without filling up all the details manually again and again.

The notification is pretty crucial for the seller too, where all the orders which has newly been placed will be informed
through here. The seller will not miss any orders at a smaller chance, and providing customers a better buying
experience. On the voucher page, seller can make a new voucher.
<hr/>

#### Validation

In my opinion, validation is necessary for every web application.
Thus, I implement it at anywhere where data corruption or errors may happen, this may include
some typo, falsify data intentionally, or value error such as filling up character at number field.
Thus, I have placed a lot of effort on validation, so that it can prevent my database to go wrong, server go downs,
getting sql injection attack,
and getting inaccurate data.
<hr/>

#### Entity Relationship Diagram (ERD)
![](C:\Users\yikso\Downloads\erd.jpg)