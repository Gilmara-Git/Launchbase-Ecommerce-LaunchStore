const express = require('express')
const routes  =  express.Router()
const HomeController =  require("../app/controllers/HomeController")


const users = require("./users") // this is the users ROUTES
const products = require("./products")


//home
routes.get('/', HomeController.index)

// products routes
routes.use('/products', products)

// users routes
routes.use("/users", users) // this is to insert '/users' in front all USERS routes 

//Alias
routes.get('/ads/create', function (req, res){  //mask route of /products/create

    return res.redirect("/products/create")
})

routes.get('/accounts', function(req, res){ 

    return res.redirect('/users/register')
})


module.exports = routes