# Fluent::Plugin::Format

Output plugin to format fields of records.
You can add or change fields using existing values.

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-format'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-format

## Usage

    <match pattern>
        type format
        tag new_tag
        key1 %{key1} changed!
        new_key1 key1 -> %{key1}
        new_key2 key1 -> %{key1}, key2 -> %{key2}
    </match>

Pass

    {
        "key1": "val1",
        "key2": "val2"
    }

Then you get

    {
        "key1": "val1 changed!",
        "key2": "val2",
        "new_key1": "key1 -> val1",
        "new_key2": "key1 -> val1, key2 -> val2"
    }

You can set `include_original_fields false` to exclude original fields.

    <match pattern>
        type format
        tag new_tag
        include_original_fields false
        html <h1>%{title}</h1><div><%{content}/div>
    </match>

Pass

    {
        "title": "Fluentd: Open Source Log Management",
        "content": "Fluentd is an open-source tool to collect events and logs. 150+ plugins instantly enables you to store the massive data for Log Search, Big Data Analytics, and Archiving (MongoDB, S3, Hadoop)."
    }

Then you get

    {
        "html": "<h1>Fluentd: Open Source Log Management</h1><div>Fluentd is an open-source tool to collect events and logs. 150+ plugins instantly enables you to store the massive data for Log Search, Big Data Analytics, and Archiving (MongoDB, S3, Hadoop).</div>"
    }