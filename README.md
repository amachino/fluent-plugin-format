# Fluent::Plugin::Format

Output plugin to format fields of records.

You can add or change fields using existing values and re-emit them.

## Installation

    $ gem install fluent-plugin-format

## Usage

    <match input.tag>
        type format
        tag output.tag
        key1 Hi, I'm %{key1}!
        new_key1 key1 is %{key1}.
        new_key2 key1 is %{key1}, key2 is %{key2}.
    </match>

Pass this record:

    input.tag: {
        "key1": "val1",
        "key2": "val2"
    }

Then you get:

    output.tag: {
        "key1": "Hi, I'm val1!",
        "key2": "val2",
        "new_key1": "key1 is val1.",
        "new_key2": "key1 is val1, key2 is val2."
    }

### include_original_fields

You can set `include_original_fields false` to exclude original fields (defalut `true`).

    <match input.tag>
        type format
        tag output.tag
        include_original_fields false
        html <h1>%{title}</h1><div><%{content}/div>
    </match>

Pass this record:

    input.tag: {
        "title": "Fluentd: Open Source Log Management",
        "content": "Fluentd is an open-source tool to collect events and logs. 150+ plugins instantly enables you to store the massive data for Log Search, Big Data Analytics, and Archiving (MongoDB, S3, Hadoop)."
    }

Then you get:

    output.tag {
        "html": "<h1>Fluentd: Open Source Log Management</h1><div>Fluentd is an open-source tool to collect events and logs. 150+ plugins instantly enables you to store the massive data for Log Search, Big Data Analytics, and Archiving (MongoDB, S3, Hadoop).</div>"
    }