/*
 * CreateImmediateAuctionMessageCallback.h
 *
 *  Created on: 13/03/2010
 *      Author: victor
 */

#ifndef CREATEIMMEDIATEAUCTIONMESSAGECALLBACK_H_
#define CREATEIMMEDIATEAUCTIONMESSAGECALLBACK_H_

#include "server/zone/packets/MessageCallback.h"
#include "server/zone/managers/auction/AuctionManager.h"


class CreateImmediateAuctionMessageCallback : public MessageCallback {
	uint64 objectID;
	uint64 vendorID;

	uint32 price;
	uint32 duration;
	byte premium;

	UnicodeString description;
public:
	CreateImmediateAuctionMessageCallback(ZoneClientSession* client, ZoneProcessServer* server) :
			MessageCallback(client, server), objectID(0), vendorID(0), price(0), duration(0), premium(0) {

	}

	void parse(Message* message) {

		objectID = message->parseLong(); // object for sale
		vendorID = message->parseLong(); // vendor

		price = message->parseInt(); // Sale price
		duration = message->parseInt(); // How long to sell for in seconds

		message->parseUnicode(description);

		if (description.length() > 2048) {			//Infinity:  Let's cap item descriptions at 2048 characters

			description = description.substr(0, 2048);

			Logger::console.error("CreateImmediateAuctionMessageCallback - Item description too long, size = " + String::valueOf(description.length()) + ", accountID = " +
				String::valueOf(client->getAccountID()) + ", IP = " + client->getIPAddress());
		}

		premium = message->parseByte(); // Premium Sale flag

	}

	void run() {
		ManagedReference<CreatureObject*> player = client->getPlayer();

		if (player == nullptr)
			return;

		ManagedReference<TangibleObject*> vendor = server->getZoneServer()->getObject(vendorID).castTo<TangibleObject*>();

		if (vendor == nullptr || (!vendor->isVendor() && !vendor->isBazaarTerminal()))
			return;

		Locker locker(player);

		AuctionManager* auctionManager = server->getZoneServer()->getAuctionManager();

		if (auctionManager != nullptr)
			auctionManager->addSaleItem(player, objectID, vendor, description, price, duration, false, premium);
	}

};

#endif /* CREATEIMMEDIATEAUCTIONMESSAGECALLBACK_H_ */
