#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define Flow_UUID "1243a672-bb82-11ed-afa1-0242ac120002"
#define Total_UUID "1243aa1e-bb82-11ed-afa1-0242ac120002"
#define Time_UUID "1243ac58-bb82-11ed-afa1-0242ac120002"

BLECharacteristic *pCharacteristicFlow;
BLECharacteristic *pCharacteristicTotal;
BLECharacteristic *pCharacteristicTime;

void setup() {
  Serial.begin(115200);
  Serial.println("Starting BLE work!");

  BLEDevice::init("ESP32-BLE-Server");
  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(SERVICE_UUID);
  pCharacteristicFlow = pService->createCharacteristic(
                                         Flow_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );
  pCharacteristicTotal = pService->createCharacteristic(
                                         Total_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );                                     
  pCharacteristicTime = pService->createCharacteristic(
                                         Time_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );
  pCharacteristicFlow->setValue("0");
  pCharacteristicTotal->setValue("0");
  pCharacteristicTime->setValue("0");
  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! Now you can read it in your phone!");\
}

void loop() {
  // put your main code here, to run repeatedly:
  pCharacteristicFlow->setValue(String(random(100)).c_str());
  pCharacteristicTotal->setValue(String(random(100)).c_str());
  pCharacteristicTime->setValue(String(random(100)).c_str());
  delay(2000);
}
