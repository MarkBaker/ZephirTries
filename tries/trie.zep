namespace Tries;

/**
 *
 * Trie class
 *
 * @package Tries
 * @copyright  Copyright (c) 2013 Mark Baker (https://github.com/MarkBaker/Tries)
 * @license    http://www.gnu.org/licenses/lgpl-3.0.txt    LGPL
 */
class Trie implements ITrie
{
    /**
     * Root-level TrieNode
     *
     * @var   TrieNode[]
     */
    protected trie = null;

    /**
     * Create a new Trie
     */
    public function __construct() -> void
    {
        let this->trie = new TrieNode();
    }

    /**
     * Adds a new entry to the Trie
     * If the specified node already exists, then its value will be overwritten
     *
     * @param   mixed   $key     Key for this node entry
     * @param   mixed   $value   Data Value for this node entry
     * @return  null
     * @throws \InvalidArgumentException if the provided key argument is empty
     *
     * @TODO Option to allow multiple values with the same key, perhaps a flag indicating overwrite or
     *          allow duplicate entries
     */
    public function add(key, value = null)
    {
        var trieNodeEntry;

        if empty(key) {
            throw new \InvalidArgumentException("Key value must not be empty");
        }

        let trieNodeEntry = this->getTrieNodeByKey(key, true);

        if trieNodeEntry->value === null {
            let trieNodeEntry->value = [value];
        } else {
            array_push(trieNodeEntry->value, value);
        }
    }

    /**
     * Backtrack toward the root of the Trie, deleting as we go, until we reach a node that we shouldn't delete
     *
     * @param   TrieNode   $trieNode   This node entry
     * @param   mixed       $key        The full key for this node entry
     * @return  null
     */
    protected function deleteBacktrace(<TrieNode> trieNode, key)
    {
        var previousKey, thisChar, previousTrieNode;

        let previousKey = substr(key, 0, -1);
        let thisChar = substr(key, -1);
        let previousTrieNode = this->getTrieNodeByKey(previousKey);
        unset previousTrieNode->children[thisChar];

        if count(previousTrieNode->children) == 0 && previousTrieNode->value === null {
            this->deleteBacktrace(previousTrieNode, previousKey);
        }
    }

    /**
     * Delete a node in the Trie
     *
     * @param   mixed   $key   The key for the node that we want to delete
     * @return  boolean        Success or failure, false if the node didn't exist
     */
    public function delete(key) -> boolean
    {
        var trieNode;

        let trieNode = this->getTrieNodeByKey(key);

        if !trieNode {
            return false;
        }

        if !empty(trieNode->children) {
            let trieNode->value = null;
        } else {
            this->deleteBacktrace(trieNode, key);
        }

        return true;
    }

    /**
     * Check if a node exists within the Trie
     *
     * @param   mixed   $key   The key for the node that we want to check
     * @return  boolean
     */
    public function isNode(key) -> boolean
    {
        var trieNode;

        let trieNode = this->getTrieNodeByKey(key);

        return trieNode !== false;
    }

    /**
     * Check if a node exists within the Trie, and is a data node
     *
     * @param   mixed   $key   The key for the node that we want to check
     * @return  boolean
     */
    public function isMember(key) -> boolean
    {
        var trieNode;

        let trieNode = this->getTrieNodeByKey(key);

        return trieNode !== false && trieNode->value !== null;
    }

    /**
     * Return an array of key/value pairs for nodes matching a specified prefix
     *
     * @param   mixed   $prefix    The key for the node that we want to return
     * @return  TrieCollection    A collection of Trie Entries for all child nodes that match the prefix value
     */
    public function search(prefix)
    {
        var trieNode;

        let trieNode = this->getTrieNodeByKey(prefix);

        if !trieNode {
            return new TrieCollection();
        }

        return this->getAllChildren(trieNode, prefix);
    }

    /**
     * Fetch a node that exists at the specified key, or false if it doesn't exist
     *
     * @param   mixed     $key       The key for the node that we want to find
     * @param   boolean   $create    Flag indicating if we should create new nodes in the Trie as we traverse it
     * @return  TrieNode | boolean   False if the specified node doesn't exist, and not flagged to create
     */
    protected function getTrieNodeByKey(key, boolean create = false)
    {
        var trieNode, keyLen, i, character;

        let trieNode = this->trie;
        let keyLen = strlen(key);
        let i = 0;

        while (i < keyLen) {
            let character = substr(key, i, 1);

            if !isset trieNode->children[character] {
                if create {
                    let trieNode->children[character] = new TrieNode();
                } else {
                    return false;
                }
            }
            let trieNode = trieNode->children[character];
            let i++;
        }

        return trieNode;
    }

    /**
     * Fetch all child nodes with a value below a specified node
     *
     * @param   TrieNode   $trieNode   Node that is our start point for the retrieval
     * @param   mixed      $prefix     Full Key for the requested start point
     * @return  TrieCollection[]       Collection of TrieEntry key/value pairs for all child nodes with a value
     */
    protected function getAllChildren(<TrieNode> trieNode, prefix)
    {
        var collection, value, character, trie;

        let collection = new TrieCollection();

        if trieNode->value !== null {
            for value in trieNode->value {
                if is_object(value) && value instanceof TrieEntry {
                    collection->add(clone value);
                } else {
                    collection->add(new TrieEntry(value, prefix));
                }
            }
        }

        if isset trieNode->children {
            for character, trie in trieNode->children {
                collection->merge(this->getAllChildren(trie, prefix . character));
            }
        }

        return collection;
    }
}
