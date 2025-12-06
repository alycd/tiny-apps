# Description

This is a simple Bash script to "encrypt" (encode) UUIDs into a URL-safe, compact Base64 format. The script removes dashes from a UUID, converts it into raw bytes, encodes it in Base64, and applies URL-safe substitutions.

# Usage

Make the script executable and run it with one or more UUIDs as arguments:

```bash
chmod +x encrypt_uuid.sh
./encrypt_uuid.sh <uuid> [more...]
```

If no arguments are provided, the script will display usage instructions.

# Example Output

```bash
$ ./encrypt_uuid.sh 123e4567-e89b-12d3-a456-426614174000

Decrypted : 123e4567-e89b-12d3-a456-426614174000
Encrypted : Ej5FZ+ibEtOkVkJmFBdAAA
--------------------------
```

# Description

This is a simple Bash script to decode Minecraft's "short UUID" format (sometimes seen in server-side plugins or APIs) back to the standard UUID format. The script handles the special character substitutions (`_` to `/` and `-` to `+`), adds necessary Base64 padding, decodes the value, and formats it as a canonical UUID with dashes.

# Usage

Run the script and provide one or more "short UUID" strings as arguments. The script will print both the original (encrypted) and decoded (decrypted) UUIDs. If no arguments are provided, usage instructions and an example are displayed.

```bash
./short-uuid-decode.sh <short-uuid> [another-short-uuid ...]
```

# Example Output

```bash
$ ./short-uuid-decode.sh ZRsDmlhHRgO0x97fZAm7Cw

Encrypted : ZRsDmlhHRgO0x97fZAm7Cw
Decrypted : 651b039a-5847-4603-b4c7-dedf6409bb0b
--------------------------
```
If you run the script without any arguments:

```bash
$ ./short-uuid-decode.sh

Usage: ./short-uuid-decode.sh <short-uuid> [more...]

Example:
  ./short-uuid-decode.sh ZRsDmlhHRgO0x97fZAm7Cw
  → 651b039a-5847-4603-b4c7-dedf6409bb0b
```

# Description

This is a Bash script to create Jira tickets using the Jira REST API. The script takes a JSON input (from stdin) containing a topic, story, and acceptance criteria, and posts it as a new ticket in your specified Jira project. It requires your Jira instance URL, email, API token, project key, and desired issue type.

# Usage

1. **Set your Jira API token as an environment variable:**
   ```bash
   export JIRA_API_TOKEN="your_api_token_here"
   ```

2. **Prepare your JSON input (e.g., `ticket.json`):**
   ```json
   {
     "Topic": "Implement login feature",
     "Story": "As a user, I want to log in so that I can access personalized features.",
     "Criteria": "- User can log in with email and password\n- Error shown on invalid credentials"
   }
   ```

3. **Run the script with your JSON input:**
   ```bash
   cat ticket.json | ./create_jira_ticket.sh
   ```

   Make sure to update the configuration variables at the top of the script (`JIRA_INSTANCE`, `JIRA_EMAIL`, `JIRA_PROJECT_KEY`, `JIRA_ISSUE_TYPE`) with your own values.

# Example Output

```
Attempting to create Jira ticket...
HTTP/1.1 201 Created
Server: AtlassianProxy/1.15.8.1
...
Location: https://martechapp.atlassian.net/rest/api/2/issue/MAR-123
...
{"id":"10001","key":"MAR-123","self":"https://martechapp.atlassian.net/rest/api/2/issue/10001"}
```

If there is a configuration or input error, you may see:
```
Error: Topic is missing from JSON input.
```
or
```
Error: JIRAPAIToken environment variable is not set.
```

# Description

This is a simple Bash script that acts as a FIFO (named pipe) reader. It waits for messages sent to a FIFO file (`/tmp/test.fifo`), and prints each received message to the terminal.

# Usage

1. Save the script to a file, for example `fifo_reader.sh`.
2. Make it executable:  
   ```bash
   chmod +x fifo_reader.sh
   ```
3. Run the script:  
   ```bash
   ./fifo_reader.sh
   ```
4. In another terminal, send messages to the FIFO:  
   ```bash
   echo "Hello World" > /tmp/test.fifo
   ```

# Example Output

```
Reader waiting for messages... (CTRL+C to exit)
Received: Hello World
Received: Another message
```
