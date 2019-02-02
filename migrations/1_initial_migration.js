var Item = artifacts.require("../blockchain/Item.sol");
var Main = artifacts.require("../blockchain/Main.sol");
var Manufacturer = artifacts.require("../blockchain/Manufacturer.sol");
var Organization = artifacts.require("../blockchain/Organization.sol");
var ServiceCenter = artifacts.require("../blockchain/ServiceCenter.sol");
var Vendor = artifacts.require("../blockchain/Vendor.sol");

module.exports = function(deployer) {
  deployer.deploy(Item);
  deployer.deploy(Main);
  deployer.deploy(Manufacturer);
  deployer.deploy(Organization);
  deployer.deploy(ServiceCenter);
  deployer.deploy(Vendor);
  deployer.deploy(Migrations);
};
