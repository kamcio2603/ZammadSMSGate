# Zammad SMS Gate Integration

This package integrates SMS Gate (https://sms-gate.app) with Zammad, allowing you to send SMS messages directly from tickets.

## Requirements

* Zammad 6.0.x or higher
* SMS Gate API account

## Installation

1. Download `zammad_sms_gate.szpm`
2. Go to Admin -> Packages in your Zammad interface
3. Upload and install the package
4. Configure your SMS Gate API key in Admin -> Channels -> SMS -> SMS Gate

## Configuration

After installation:

1. Go to Admin -> Channels -> SMS
2. Select "SMS Gate" as provider
3. Enter your API key
4. Save the configuration

## Usage

Once configured, you can:
- Send SMS directly from tickets
- Configure SMS notifications in triggers
- Use SMS templates in your communication

## License

MIT License

